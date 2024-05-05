#let creationDate = datetime(year: 2024, month: 05, day: 05)

#set document(
  title: "Metody Numeryczne - Projekt 3: Aproksymacja profilu wysokościowego terenu",
  author: "Stanisław Nieradko 193044 <stanislaw@nieradko.com>",
  date: creationDate
)

#set page(
  paper: "a4",
  margin: (x: 1cm, y: 1cm),
  numbering: "1/1",
  footer: context [
    #set text(size: 9pt)
    *Aproksymacja profilu wysokościowego terenu* Stanisław Nieradko 193044
    #h(1fr)
    #counter(page).display(
      "1 / 1",
      both: true
    )
  ]
)

#align(center)[
  #stack(
    dir: ttb,
    text(size: 24pt, weight: "semibold")[Aproksymacja profilu wysokościowego terenu],
    v(10pt),
    text(size: 14pt)[Metody Numeryczne - Projekt 3],
    v(20pt),
    text(size: 12pt)[Stanisław Nieradko 193044],
    v(10pt),
    text(size: 12pt)[#creationDate.display()]
  )
]


= 1. Wstęp <Wstęp>

Celem projektu jest zaimplementowanie oraz porównanie algorytmów interpolacji funkcji na przykładzie aproksymacji profilu wysokościowego terenu.

W ramach projektu zaimplementowano:
- metodę interpolacji wielomianowej Lagrange'a
- metodę interpolacji wykorzystującą funkcje sklejane trzeciego stopnia

wraz z wymaganymi funkcjami macierzowymi oraz algorytmami rozwiązywania układów równań liniowych.

Implementacja została wykonana w języku Python, bez wykorzystania zewnętrznych bibliotek do jakichkolwiek obliczeń numerycznych. Wykorzystane zostały biblioteki do obsługi plików (_Pandas_) oraz rysowania wykresów (_matplotlib_).

W ramach projektu porównane zostaną wyniki interpolacji dla 5 różnych zestawów danych o różnych cechach, w celu zbadania zachowania obu metod w różnych warunkach. Ponadto zostaną zbadane różnice wynikające z różnych parametrów interpolacji, takich jak liczba punktów czy ich rozmieszczenie.

== 1.1. Interpolacja wielomianowa Lagrange'a

Pierwszą zaimplementowaną metodą była interpolacja wielomianowa Lagrange'a. Metoda ta polega na znalezieniu wielomianu stopnia n-1, który przechodzi przez n punktów. 

Jest to możliwe dzięki policzeniu _bazy Lagrange'a_ dla każdego z punktów:

$ phi_i (x) = limits(product)_(j=1,j!=i)^(n+1) frac(x - x_j,x_i - x_j) $

a następnie złożeniu ich w jeden wielomian:

$ F(x) = sum_(i=1)^(n+1) y_i phi_i (x) $

Metoda ta jest bardzo prosta w implementacji, jednakże ma swoje wady w postaci efektu Rungego, który polega na oscylacjach wielomianu na krańcach przedziału interpolacji, i może być zaobserwowany w dalszych częściach raportu.

== 1.2. Interpolacja funkcjami sklejanymi trzeciego stopnia

Drugą zaimplementowaną metodą była interpolacja funkcjami sklejanymi trzeciego stopnia. Metoda ta polega na znalezieniu funkcji sklejanej, która przechodzi przez wszystkie punkty, a jej pochodne pierwszego i drugiego rzędu są ciągłe.

Metoda ta polega na znalezieniu funkcji sklejanej w postaci:

$ S_i (x) = a_i + b_i (x - x_i) + c_i (x - x_i)^2 + d_i (x - x_i)^3 $

gdzie współczynniki $ a_i, b_i, c_i, d_i $ są znane dla każdego z przedziałów.

W celu znalezienia współczynników, należy rozwiązać układ równań liniowych, który jest złożony z równań dla każdego z punktów.

Metoda ta jest bardziej skomplikowana w implementacji, jednakże pozwala na uzyskanie lepszych wyników, bez efektu Rungego.