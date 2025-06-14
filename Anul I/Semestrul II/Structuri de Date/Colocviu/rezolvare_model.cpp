#include <iostream>

#include <queue>
#include <stack>

#include <set>
#include <string>

#include <unordered_map>

using namespace std;

struct Volum {
	string categorie;
	int numar;
	Volum(): categorie(""), numar(0){}
	Volum(string c, int n) {
		this->categorie = c;
		this->numar = n;
	}
};

void Exercitiul1() {
	priority_queue <int> coada;
	int n, k;
	cin >> n >> k;
	for (int i = 0; i < n; i++) {
		int val;
		cin >> val;
		if (coada.size() < k)
			coada.push(-1*val);
		else {
			coada.pop();
			coada.push(-1*val);
		}
	}

	stack <int> stiva;
	for (int i = 0; i < k; i++) {
		stiva.push(-1*coada.top());
		coada.pop();
	}

	while (!stiva.empty()) {
		cout << stiva.top() << ' ';
		stiva.pop();
	}
	// 7 3
	// 5 3 10 1 4 8 7
}

void Exercitiul2() {
	set <int> s;
	int nr_operatii;
	cin >> nr_operatii;
	cin.get();

	for (int i = 0; i < nr_operatii; i++) {
		string operatie;
		cin >> operatie;

		if (operatie == "Cauta") {
			int nr;
			cin >> nr;
			if (s.find(nr) != s.end())
				cout << "DA\n";
			else
				cout << "NU\n";
		}

		else if (operatie == "Adauga") {
			int nr;
			cin >> nr;
			s.insert(nr);
		}

		else if (operatie == "Arata") {
			auto it = s.begin();
			while (it != s.end()) {
				cout << *it << ' ';
				it++;
			}
			cout << endl;
		}
	}
	/*
	8
	Adauga 5
	Adauga 3
	Cauta 3
	Arata
	Adauga 7
	Cauta 7
	Cauta 1
	Arata
	*/
}

void Exercitiul3() {
	unordered_map<string, Volum> carte;
	unordered_map<string, int> categ;

	int numar_operatii;
	cin >> numar_operatii;
	for (int op = 0; op < numar_operatii; op++) {
		string operatie;
		cin >> operatie;
		if (operatie == "ADD") {
			string titlu, cat;
			int k;
			cin >> titlu >> cat >> k;

			auto aux = carte.find(titlu);
			if (aux == carte.end() || (aux != carte.end() && carte[titlu].categorie == cat)) {
				carte[titlu].categorie = cat;
				carte[titlu].numar += k;

				categ[cat] += k;
			}
			else
				cout << "INVALID\n";
		}
		else if (operatie == "REMOVE") {
			string titlu;
			int k;
			cin >> titlu >> k;

			int nr_sterse;
			auto aux = carte.find(titlu);
			if (aux != carte.end()) {
				string c = carte[titlu].categorie;
				if (carte[titlu].numar - k <= 0) {
					nr_sterse = carte[titlu].numar;
					carte.erase(titlu);
				}
				else {
					carte[titlu].numar -= k;
					nr_sterse = k;
				}

				categ[c] -= nr_sterse;
			}
		}
		else if (operatie == "CHECK") {
			string titlu;
			cin >> titlu;

			auto aux = carte.find(titlu);
			if (aux != carte.end())
				cout << carte[titlu].categorie + '\n';
			else
				cout << "NU\n";
		}
		else {
			string cat;
			cin >> cat;
			auto aux = categ.find(cat);
			if (aux != categ.end())
				cout << categ[cat] << '\n';
			else
				cout << "0\n";
		}
	}
	/*
	10
	ADD EnigmaMagica Magie 3
	ADD PovestiVechi Istorie 2
	CHECK EnigmaMagica
	ADD EnigmaMagica Istorie 1
	REMOVE EnigmaMagica 1
	COUNT Magie
	REMOVE EnigmaMagica 2
	CHECK EnigmaMagica
	COUNT Magie
	COUNT Istorie
	*/
}

int main() {
	// Exercitiul1();

	// Exercitiul2();

	// Exercitiul3();

	return 0;
}