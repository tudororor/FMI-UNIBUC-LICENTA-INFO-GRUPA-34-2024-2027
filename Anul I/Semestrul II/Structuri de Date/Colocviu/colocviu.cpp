#include <iostream>
#include <queue>
#include <set>
#include <unordered_map>

using namespace std;

struct Componenta {
	string cat;
	int unitati;

	Componenta(): cat(""), unitati(0){}
	Componenta(string c, int u) {
		this->cat = c;
		this->unitati = u;
	}
};

void Problema1() {
	int N, K;
	cin >> N >> K;

	priority_queue<int, vector<int>, greater<int>> mostre;
	for (int i = 0; i < N; i++) {
		int m;
		cin >> m;
		if (mostre.size() < K)
			mostre.push(m);
		else {
			if (m > mostre.top()) {
				mostre.pop();
				mostre.push(m);
			}
		}
	}

	while (!mostre.empty()) {
		cout << mostre.top() << ' ';
		mostre.pop();
	}
	/*
	 7 3
	 5 3 10 1 4 8 7
	*/
}

void Problema2() {
	int Q;
	cin >> Q;
	set<int> s;
	for (int i = 0; i < Q; i++) {
		int op;
		cin >> op;

		if (op == 0) {
			int x;
			cin >> x;
			s.insert(x);
		}
		else if (op == 1) {
			int x;
			cin >> x;
			if (s.find(x) != s.end())
				cout << "DA\n";
			else
				cout << "NU\n";
		}
		else if (op == 2) {
			auto it = s.begin();
			while (it != s.end()) {
				cout << *it << ' ';
				it++;
			}
			cout << endl;
		}
	}
	/*
	 3
	 0 5
	 1 5
	 2
	*/
}

void Problema3() {
	unordered_map<string, Componenta> comp;
	unordered_map<string, int> categorie;
	int n;
	cin >> n;
	for (int i = 0; i < n; i++) {
		string comanda;
		cin >> comanda;
		if (comanda == "ADD") {
			string N, T;
			int Q;
			cin >> N >> T >> Q;

			auto aux = comp.find(N);
			if (aux == comp.end() || (aux != comp.end() && comp[N].cat == T)) {
				comp[N].cat = T;
				comp[N].unitati += Q;

				categorie[T] += Q;
			}
			else
				cout << "INVALID\n";
		}
		else if (comanda == "REMOVE") {
			string N;
			int Q;
			cin >> N >> Q;

			int nr_sterse;
			auto aux = comp.find(N);
			if (aux != comp.end()) {
				string c = comp[N].cat;
				if (comp[N].unitati - Q <= 0) {
					nr_sterse = comp[N].unitati;
					comp.erase(N);
				}
				else {
					comp[N].unitati -= Q;
					nr_sterse = Q;
				}

				categorie[c] -= nr_sterse;
			}
		}
		else if (comanda == "CHECK") {
			string N;
			cin >> N;

			auto aux = comp.find(N);
			if (aux != comp.end())
				cout << comp[N].cat + '\n';
			else
				cout << "NU\n";
		}
		else if (comanda == "COUNT") {
			string T;
			cin >> T;
			auto aux = categorie.find(T);
			if (aux != categorie.end())
				cout << categorie[T] << '\n';
			else
				cout << "0\n";
		}
	}
	/*
	 10
	 ADD Alpha Procesor 5
	 ADD Beta Senzor 3
	 CHECK Alpha
	 ADD Alpha Memorie 2
	 REMOVE Alpha 2
	 COUNT Procesor
	 REMOVE Alpha 3
	 CHECK Alpha
	 COUNT Procesor
	 COUNT Senzor
	*/
}

int main() {
	// Problema1();

	// Problema2();

	// Problema3();

	return 0;
}
