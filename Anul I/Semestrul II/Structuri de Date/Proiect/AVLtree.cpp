#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

class Node {
public:
	int key;
	Node* left;
	Node* right;
	int height;

	Node (int value): key(value), left(nullptr), right(nullptr), height(1) {}
};

class AVLtree {
private:
	Node* root;

	int height(Node* node) {
		if (node == nullptr)
			return 0;
		return node->height;
	}

	void updateHeight(Node* node) {
		if (node == nullptr)
			return;
		node->height = 1 + max(height(node->left), height(node->right));
	}

	int balanceFactor(Node* node) {
		if (node == nullptr)
			return 0;
		return height(node->left) - height(node->right);
	}

	Node* rightRotation(Node* parent) {
		Node* child = parent->left;
		Node* subtree = child->right;

		child->right = parent;
		parent->left = subtree;

		updateHeight(parent);
		updateHeight(child);

		return child;
	}

	Node* leftRotation(Node* parent) {
		Node* child = parent->right;
		Node* subtree = child->left;

		child->left = parent;
		parent->right = subtree;

		updateHeight(parent);
		updateHeight(child);

		return child;
	}

	Node* insert(Node* node, int key) {
		if (node == nullptr)
			return new Node(key);

		if (key < node->key)
			node->left = insert(node->left, key);
		else if (key > node->key)
			node->right = insert(node->right, key);
		else
			return node;

		updateHeight(node);

		int balance = balanceFactor(node);

		// left left
		if (balance > 1 && key < node->left->key)
			return rightRotation(node);

		// right right
		if (balance < -1 && key > node->right->key)
			return leftRotation(node);

		// left right
		if (balance > 1 && key > node->left->key) {
			node->left = leftRotation(node->left);
			return rightRotation(node);
		}

		// right left
		if (balance < -1 && key < node->right->key) {
			node->right = rightRotation(node->right);
			return leftRotation(node);
		}

		return node;
	}

	Node* minimumValue(Node* node) {
		Node* current = node;
		while (current->left != nullptr)
			current = current->left;
		return current;
	}

	Node* deleteNode(Node* node, int key) {
		if (node == nullptr)
			return node;

		if (key < node->key)
			node->left = deleteNode(node->left, key);
		else if (key > node->key)
			node->right = deleteNode(node->right, key);
		else {
			if ((node->left == nullptr) || (node->right == nullptr)) {
				Node* aux = node->left ? node->left : node->right;
				if (aux == nullptr) {
					aux = node;
					node = nullptr;
				}
				else
					*node = *aux;
				delete aux;
			}
			else {
				Node* aux = minimumValue(node->right);
				node->key = aux->key;
				node->right = deleteNode(node->right, aux->key);
			}
		}

		if (node == nullptr)
			return node;

		updateHeight(node);

		int balance = balanceFactor(node);

		// left left
		if (balance > 1 && balanceFactor(node->left) >= 0)
			return rightRotation(node);

		// right right
		if (balance < -1 && balanceFactor(node->right) <= 0)
			return leftRotation(node);

		// left right
		if (balance > 1 && balanceFactor(node->left) < 0) {
			node->left = leftRotation(node->left);
			return rightRotation(node);
		}

		// right left
		if (balance < -1 && balanceFactor(node->right) > 0) {
			node->right = rightRotation(node->right);
			return leftRotation(node);
		}

		return node;
	}

	void inorder(Node* node) {
		if (node != nullptr) {
			inorder(node->left);
			cout << node->key << " ";
			inorder(node->right);
		}
	}

	bool search(Node* node, int key) {
		if (node == nullptr)
			return false;
		if (node->key == key)
			return true;
		if (key < node->key)
			return search(node->left, key);
		return search(node->right, key);
	}

public:
	AVLtree(): root(nullptr){}

	void insert(int key) {
		root = insert(root, key);
	}

	void remove(int key) {
		root = deleteNode(root, key);
	}

	bool search(int key) {
		return search(root, key);
	}

	void printInorder() {
		inorder(root);
		cout << endl;
	}
};

int main()
{
	AVLtree tree;
	int optiune, valoare, n;
	vector<int> valori;

	do {
		cout << "1. Inserare noduri\n";
		cout << "2. Stergere noduri\n";
		cout << "3. Cautare noduri\n";
		cout << "4. Afisare in ordine\n";
		cout << "5. Oprire\n";
		cin >> optiune;

		switch(optiune) {
			case 1:
				valori.clear();
				cout << "Cate valori vrei sa inserezi?\n";
				cin >> n;
				cout << "Introdu valoarile de inserat:\n";
				for (int i = 0; i < n; i++) {
					cin >> valoare;
					valori.push_back(valoare);
				}
				for (auto val: valori)
					tree.insert(val);
				break;

			case 2:
				valori.clear();
				cout << "Cate valori vrei sa stergi?\n";
				cin >> n;
				cout << "Introdu valoarile de sters:\n";
				for (int i = 0; i < n; i++) {
					cin >> valoare;
					valori.push_back(valoare);
				}
				for (auto val: valori)
					tree.remove(val);
				break;

			case 3:
				valori.clear();
				cout << "Pentru fiecare valoare se va afisa 0/1. Cate valori vrei sa cauti?\n";
				;
				cin >> n;
				cout << "Introdu valoarile de cautat:\n";
				for (int i = 0; i < n; i++) {
					cin >> valoare;
					valori.push_back(valoare);
				}
				for (auto val: valori) {
					cout << tree.search(val) << ' ';
				}
				cout << endl;
				break;

			case 4:
				cout << "Elementele arborelui in ordine:\n";
				tree.printInorder();
				break;

			case 5:
				cout << "Paaaaaaaaaa\n";
				break;

			default:
				cout << "Optiune invalida\n";
		}
	} while(optiune != 5);

	return 0;
}