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

$ phi.alt_i (x) = limits(product)_(j=1,j!=i)^(n+1) frac(x - x_j,x_i - x_j) $

a następnie złożeniu ich w jeden wielomian:

$ F(x) = sum_(i=1)^(n+1) y_i phi.alt_i (x) $

Metoda ta jest bardzo prosta w implementacji, jednakże ma swoje wady w postaci efektu Rungego, który polega na oscylacjach wielomianu na krańcach przedziału interpolacji, i może być zaobserwowany w dalszych częściach raportu.

== 1.2. Interpolacja funkcjami sklejanymi trzeciego stopnia

Drugą zaimplementowaną metodą była interpolacja funkcjami sklejanymi trzeciego stopnia. Metoda ta polega na znalezieniu funkcji sklejanej, która przechodzi przez wszystkie punkty, a jej pochodne pierwszego i drugiego rzędu są ciągłe.

Metoda ta polega na znalezieniu funkcji sklejanej w postaci:

$ S_i (x) = a_i + b_i (x - x_i) + c_i (x - x_i)^2 + d_i (x - x_i)^3 $

gdzie współczynniki $ a_i, b_i, c_i, d_i $ są znane dla każdego z przedziałów.

W celu znalezienia współczynników, należy rozwiązać układ równań liniowych, który zbudowany jest na podstawie warunków ciągłości pierwszej i drugiej pochodnej funkcji sklejanej w każdym z punktów.

Warunki te są zdefiniowane jako:

1. W punkcie $x_i$ wartość funkcji sklejanej jest równa wartości funkcji interpolowanej:
$ S_i (x_i) = y_i $

2. Dla granic przedziałów $[x_i, x_{i+1}]$ pochodne pierwsze i drugie funkcji sklejanej są równe:
$ S_i'(x_{i+1}) = S_{i+1}'(x_{i+1}) $
$ S_i''(x_{i+1}) = S_{i+1}''(x_{i+1}) $

3. Dla punktów skrajnych pochodne drugie są równe zeru:
$ S_1''(x_1) = 0 $
$ S_n''(x_n) = 0 $

Metoda ta jest bardziej skomplikowana w implementacji, jednakże pozwala na uzyskanie lepszych wyników, *bez efektu Rungego*.

== 2. Efekt Rungego <Runge>

Wspomniany wcześniej efekt Rungego jest zjawiskiem, które występuje w interpolacji wielomianowej, polegającym na oscylacjach wielomianu na krańcach przedziału interpolacji. Jest to zjawisko, które występuje w przypadku interpolacji wielomianowej z równoodległymi węzłami, i jest wynikiem zbyt dużej liczby punktów interpolacji. Zjawisko to jest szczególnie widoczne w przypadku interpolacji wielomianowej Lagrange'a, gdzie oscylacje mogą być bardzo duże.

#figure(
  image("../plots/runge_phenomenon_example.png"),
  caption: "Przykładowy efekt Rungego"
)

Efekt ten może zostać zniwelowany poprzez zmianę rozmieszczenia punktów interpolacji (np. przy pomocy węzłów Czebyszewa) lub zastosowanie innych metod interpolacji, takich jak funkcje sklejane.

== 3. Zestawy danych i wyniki interpolacji <Data>

W ramach projektu wykonano analizę wyników interpolacji dla 5 zestawów danych pochodzących z przekazanego pliku `.zip` z danymi. Zestawy te różnią się między sobą liczbą punktów, ich rozmieszczeniem oraz wartościami.

== 3.1. Zestaw danych Chełm

#figure(
  image("../plots/chelm/1_original_data.png"),
  caption: "Zestaw danych Chełm"
)

Pierwszy zestaw danych pochodzi z miasta Chełm, i zawiera 512 punktów. Punkty te ulegają delikatnym i płynnym zmianom wysokości w stosunku do siebie, dzięki czemu interpolacja powinna przebiegać bez większych problemów.

#figure(
  image("../plots/chelm/2_1_lagrange_linspace.png"),
  caption: "Interpolacja wielomianowa Lagrange'a bez węzłów Czebyszewa"
)

Jak widać na przytoczonym wykresie interpolacja wielomianowa Lagrange'a z równoodległymi węzłami rozjeżdża się już przy ok. 20 punktach pomiaru poprzez efekt Rungego.

#figure(
  image("../plots/chelm/2_1_lagrange_chebyshev.png"),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa"
)

Zastosowanie węzłów Czebyszewa pozwala na uniknięcie efektu Rungego, dzięki czemu interpolacja osiąga zadowalające wyniki już przy 50 punktach pomiaru.

#figure(
  image("../plots/chelm/2_2_cubic_spline.png"),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia"
)

Interpolacja funkcjami sklejanymi trzeciego stopnia pozwala na uzyskanie jeszcze lepszych wyników interpolacji, bez efektu Rungego, dzięki czemu nawet przy 52 punktach pomiaru interpolacja jest bardzo dokładna.

Podsumowując - w przypadku zestawu danych Chełm, interpolacja funkcjami sklejanymi trzeciego stopnia daje najlepsze wyniki, zarówno pod względem dokładności, jak i wydajności. Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa również daje zadowalające wyniki, jednakże jest mniej dokładna niż funkcje sklejane. Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami jest najmniej dokładna, a efekt Rungego jest bardzo widoczny już przy stosunkowo niewielkiej liczbie punktów pomiaru.

Żadnym zaskoczeniem nie jest fakt, że zwiększenie ilości punktów pomiarowych znacząco poprawia jakość interpolacji, jednakże w przypadku interpolacji wielomianowej z równoodległymi węzłami, zbyt duża liczba punktów może prowadzić do efektu Rungego, uniemożliwiając niekiedy poprawne odwzorowanie funkcji.

== 3.2. Zestaw danych Genoa-Rapallo

#figure(
  image("../plots/genoa_rapallo/1_original_data.png"),
  caption: "Zestaw danych Geo-Rapallo"
)

Drugi zestaw danych pochodzi z miasta Genoa-Rapallo, i także zawiera 512 punktów. Punkty te ulegają gwałtownym zmianom wysokości w stosunku do siebie, dzięki czemu interpolacja powinna być bardziej wymagająca. Na dodatek następuje gwałtowny spadek wysokości w końcowej części zestawu danych.

#figure(
  image("../plots/genoa_rapallo/2_1_lagrange_linspace.png"),
  caption: "Interpolacja wielomianowa Lagrange'a bez węzłów Czebyszewa"
)

Jak widać na przytoczonym wykresie interpolacja wielomianowa Lagrange'a z równoodległymi węzłami rozjeżdża się już przy ok. 15 punktach pomiaru poprzez efekt Rungego. Widać także że metoda ta nie radzi sobie z gwałtownymi zmianami wysokości i znacząco upraszcza profil terenu.

#figure(
  image("../plots/genoa_rapallo/2_1_lagrange_chebyshev.png"),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa"
)

Zastosowanie węzłów Czebyszewa pozwala na uniknięcie efektu Rungego (na większości funkcji), jednakże metoda ta nadal nie radzi sobie z gwałtownymi zmianami wysokości. Interpolacja daje jedynie uproszczony profil terenu oraz widać oscylację na końcu profilu terenu nawet przy 100 punktach pomiaru.

#figure(
  image("../plots/genoa_rapallo/2_2_cubic_spline.png"),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia"
)

Interpolacja funkcjami sklejanymi trzeciego stopnia daje znacznie lepsze wyniki. Profil terenu jest dokładniejszy, a gwałtowne zmiany wysokości nie wpływają na jakość interpolacji. Niestety z uwagi na trudne warunki terenowe, interpolacja nie jest idealna, jednakże jest znacznie lepsza niż w przypadku interpolacji wielomianowej.

W przypadku zestawu danych Genoa-Rapallo, interpolacja funkcjami sklejanymi trzeciego stopnia nadal daje najlepsze wyniki, zarówno pod względem dokładności, jak i wydajności. Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa lub bez, daje niezadowalające wyniki pod względem dokładności odwzorowania funkcji oraz nie radzi sobie z gwałtownymi zmianami wysokości. W przypadku tego zestawu danych, efekt Rungego widoczny jest nawet przy zastosowaniu węzłów Czebyszewa, co pokazuje jak trudne warunki terenowe mogą wpłynąć na jakość interpolacji.

Interpolacja funkcjami sklejanymi trzeciego stopnia, mimo iż nie uzyskała idealnych wyników, pozwala na uzyskanie najdokładniejszej interpolacji, nawet w trudnych warunkach terenowych.

== 3.3 Pozostałe zestawy danych

== 3.3.1. Zestaw danych HelYeah

#figure(
  image("../plots/hel_yeah/1_original_data.png"),
  caption: "Zestaw danych HelYeah"
)

#figure(
  image("../plots/hel_yeah/2_1_lagrange_linspace.png"),
  caption: "Interpolacja wielomianowa Lagrange'a bez węzłów Czebyszewa"
)

#figure(
  image("../plots/hel_yeah/2_1_lagrange_chebyshev.png"),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa"
)

#figure(
  image("../plots/hel_yeah/2_2_cubic_spline.png"),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia"
)

== 3.3.2. Zestaw danych Stale

#figure(
  image("../plots/stale/1_original_data.png"),
  caption: "Zestaw danych Stale"
)

#figure(
  image("../plots/stale/2_1_lagrange_linspace.png"),
  caption: "Interpolacja wielomianowa Lagrange'a bez węzłów Czebyszewa"
)

#figure(
  image("../plots/stale/2_1_lagrange_chebyshev.png"),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa"
)

#figure(
  image("../plots/stale/2_2_cubic_spline.png"),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia"
)

== 3.3.3. Zestaw danych Wielki Kanion

#figure(
  image("../plots/wielki_kanion/1_original_data.png"),
  caption: "Zestaw danych Wielki Kanion"
)

#figure(
  image("../plots/wielki_kanion/2_1_lagrange_linspace.png"),
  caption: "Interpolacja wielomianowa Lagrange'a bez węzłów Czebyszewa"
)

#figure(
  image("../plots/wielki_kanion/2_1_lagrange_chebyshev.png"),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa"
)

#figure(
  image("../plots/wielki_kanion/2_2_cubic_spline.png"),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia"
)

== 4. Podsumowanie

W ramach projektu zaimplementowano dwie metody interpolacji funkcji - wielomianową Lagrange'a oraz funkcjami sklejanymi trzeciego stopnia. Obie metody zostały przetestowane na 5 różnych zestawach danych o różnych cechach, w celu zbadania zachowania obu metod w różnych warunkach.

Wyniki pokazują, że interpolacja funkcjami sklejanymi trzeciego stopnia daje najlepsze wyniki, zarówno pod względem dokładności, jak i wydajności. Metoda ta pozwala na uzyskanie dokładnej interpolacji nawet w trudnych warunkach terenowych, bez efektu Rungego.

W przypadku metody interpolacji funkcjami sklejanymi trzeciego stopnia, zwiększanie liczby punktów pomiarowych zawsze poprawia jakość interpolacji, jednakże nawet przy niewielkiej liczbie punktów interpolacja jest stosunkowo dokładna.

Metoda wielomianowa Lagrange'a potrafi dawać zadowalające wyniki dla niewielkiej liczby punktów pomiarowych w przypadku równoodległych węzłów pomiarowych lub większej liczby punktów w przypadku węzłów Czebyszewa. Niestety metoda ta jest mniej dokładna niż funkcje sklejane, a efekt Rungego jest bardzo widoczny już przy stosunkowo niewielkiej liczbie punktów pomiaru przy zastosowaniu równoodległych węzłów lub przy szybko zmieniającej się funkcji terenu.

Mowiąc o rozmieszczeniu punktów pomiarowych, w przypadku interpolacji wielomianowej Lagrange'a, zastosowanie węzłów Czebyszewa pozwala na uniknięcie efektu Rungego i (zazwyczaj) poprawia on wynik interpolacji kosztem jej dokładności w okolicy środka analizowanej funkcji. W przypadku interpolacji funkcjami sklejanymi trzeciego stopnia, rozmieszczenie punktów pomiarowych nie ma większego znaczenia, a interpolacja zawsze jest dokładna.

Podsumowując - w przypadku interpolacji profilu wysokościowego terenu, zaleca się stosowanie interpolacji funkcjami sklejanymi trzeciego stopnia, ze względu na ich dokładność i brak efektu Rungego. W przypadku braku możliwości zastosowania funkcji sklejanych, interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa daje zadowalające wyniki, jednakże jest mniej dokładna niż funkcje sklejane. Metoda ta powinna dać zadowalające wyniki w większości przypadków, aczkolwiek gdy planujemy analizować dynamicznie zmieniającą się funkcję terenu, zaleca się zastosowanie funkcji sklejanych.