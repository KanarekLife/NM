#let creationDate = datetime(year: 2024, month: 05, day: 09)

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

#show figure.caption: it => [
  #if it.supplement == [Figure] [
    Rysunek  #it.counter.display()#it.separator #it.body
  ] else if it.supplement == [Table] [
    Tabela  #it.counter.display()#it.separator #it.body
  ] else [
    #it.supplement #it.numbering#it.separator #it.body
  ]
]

#set heading(numbering: "1.1")

#show outline.entry.where(level: 1): it => {
  v(12pt, weak: true)
  strong(it)
}

#align(horizon)[
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
]

#pagebreak()

#outline(
    title: "Spis treści",
    indent: auto
)


#pagebreak()


= Wstęp

Celem projektu jest zaimplementowanie oraz porównanie algorytmów interpolacji funkcji na przykładzie aproksymacji profilu wysokościowego terenu.

W ramach projektu zaimplementowano:
- metodę interpolacji wielomianowej Lagrange'a
- metodę interpolacji wykorzystującą funkcje sklejane trzeciego stopnia

wraz z wymaganymi funkcjami macierzowymi oraz algorytmami rozwiązywania układów równań liniowych.

Implementacja została wykonana w języku Python, bez wykorzystania zewnętrznych bibliotek do jakichkolwiek obliczeń numerycznych. Wykorzystane zostały biblioteki do obsługi plików (_Pandas_) oraz rysowania wykresów (_matplotlib_).

W ramach projektu porównane zostaną wyniki interpolacji dla 5 różnych zestawów danych o różnych cechach, w celu zbadania zachowania obu metod w różnych warunkach. Ponadto zostaną zbadane różnice wynikające z różnych parametrów interpolacji, takich jak liczba punktów czy ich rozmieszczenie.

== Interpolacja wielomianowa Lagrange'a

Pierwszą zaimplementowaną metodą była interpolacja wielomianowa Lagrange'a. Metoda ta polega na znalezieniu wielomianu stopnia n-1, który przechodzi przez n punktów. 

Jest to możliwe dzięki policzeniu _bazy Lagrange'a_ dla każdego z punktów:

$ phi.alt_i (x) = limits(product)_(j=1,j!=i)^(n+1) frac(x - x_j,x_i - x_j) $

a następnie złożeniu ich w jeden wielomian:

$ F(x) = sum_(i=1)^(n+1) y_i phi.alt_i (x) $

Metoda ta jest bardzo prosta w implementacji, jednakże ma swoje wady w postaci efektu Rungego, który polega na oscylacjach wynikowego wielomianu na krańcach przedziału interpolacji.

#figure(
  image("../plots/runge_phenomenon_example.png"),
  caption: "Przykładowy efekt Rungego"
)

Efekt ten może zostać zniwelowany poprzez zmianę rozmieszczenia punktów interpolacji (np. przy pomocy węzłów Czebyszewa) co także zostało zaimplementowane w ramach projektu.

== Interpolacja funkcjami sklejanymi trzeciego stopnia

Drugą zaimplementowaną metodą była interpolacja funkcjami sklejanymi trzeciego stopnia. Metoda ta polega na znalezieniu funkcji sklejanej, która przechodzi przez wszystkie punkty, a jej pochodne pierwszego i drugiego rzędu są ciągłe.

Sklejana funkcja trzeciego stopnia na przedziale $[x_i, x_(i+1)]$ ma postać:

$ S_i (x) = a_i + b_i (x - x_i) + c_i (x - x_i)^2 + d_i (x - x_i)^3 $

gdzie współczynniki $a_i, b_i, c_i, d_i$ są znane dla każdego z przedziałów.

W celu znalezienia współczynników, należy rozwiązać układ równań liniowych, który zbudowany jest na podstawie warunków ciągłości pierwszej i drugiej pochodnej funkcji sklejanej w każdym z punktów.

Warunki te są zdefiniowane jako:

1. W punkcie $x_i$ wartość funkcji sklejanej jest równa wartości funkcji interpolowanej:
$ S_i (x_i) = y_i $

2. Dla granic przedziałów $[x_i, x_(i+1)]$ pochodne pierwsze i drugie funkcji sklejanej są równe:
$ S_i '(x_(i+1)) = S_(i+1) '(x_(i+1)) $
$ S_i ''(x_(i+1)) = S_(i+1) ''(x_(i+1)) $

3. Dla punktów skrajnych pochodne drugie są równe zeru:
$ S_1 ''(x_1) = 0 $
$ S_n ''(x_n) = 0 $

Metoda ta jest bardziej skomplikowana w implementacji, jednakże pozwala na uzyskanie lepszych wyników, *bez efektu Rungego*.

= Zestawy danych

W ramach projektu wykonano analizę wyników interpolacji dla paru zestawów danych pochodządzych z pliku `.zip` z danymi. Zestawy te różnią się między gwałtownością zmian wysokości, ich rozmieszczeniem oraz wartościami.

Analizowane zestawy danych to:
- `chelm.csv` - 512 punktów z dzielnicy Chełm w Gdańsku. Punkty te ulegają delikatnym i płynnym zmianom wysokości w stosunku do siebie, dzięki czemu interpolacja powinna przebiegać bez większych problemów.\
- `genoa_rapallo.csv` - 512 punktów z miasta Genoa-Rapallo. Punkty te ulegają gwałtownym zmianom wysokości w stosunku do siebie, dzięki czemu interpolacja powinna być bardziej wymagająca. Na dodatek następuje gwałtowny spadek wysokości w końcowej części zestawu danych, co dodatkowo utrudnia interpolację.
- `hel_yeah.csv` - 512 punktów nieznanego pochodzenia. Punkty te ulegają bardzo gwałtownym zmianom wysokości w stosunku do siebie, dzięki czemu interpolacja powinna być nawet bardziej wymagająca.
- `stale.csv` - 512 punktów nieznanego pochodzenia. Funkcja terenu jest bardzo płaska oraz delikatnie rośnie przez całą swoją długość, co powinno ułatwić interpolację.
- `wielki_kanion.csv` - 512 punktów z Wielkiego Kanionu w Kolorado, USA. Funkcja terenu ulega gwałtownej zmianie wysokości w środku zestawu danych ale jest ona zdecydowanie prosztza niż w przypadku Genoa-Rapallo lub HelYeah.

#grid(
  columns: (1fr, 1fr),
  rows: (auto, auto, auto),
  gutter: 5pt,
  figure(
    image("../plots/chelm/original_function.png"),
    caption: "Funkcja terenu dla zestawu danych Chełm"
  ),
  figure(
    image("../plots/genoa_rapallo/original_function.png"),
    caption: "Funkcja terenu dla zestawu danych Genoa-Rapallo"
  ),
  figure(
    image("../plots/hel_yeah/original_function.png"),
    caption: "Funkcja terenu dla zestawu danych HelYeah"
  ),
  figure(
    image("../plots/stale/original_function.png"),
    caption: "Funkcja terenu dla zestawu danych Stale"
  ),
  figure(
    image("../plots/wielki_kanion/original_function.png"),
    caption: "Funkcja terenu dla zestawu danych Wielki Kanion"
  )
)

= Podstawowa analiza wyników interpolacji

Podstawowa analiza wyników interpolacji dla każdego z zestawów danych polega na zbadaniu wpływu ilości punktów pomiarowych oraz ich rozmieszczenia na jakość interpolacji. Analiza została przeprowadzona dla zestawów `chelm.csv` oraz `genoa_rapallo.csv`. Analiza została przeprowadzone dla 11, 26, 52 oraz 103 punktów pomiarowych (z 512 łącznie).

Jak widać na umieszczonych dalej wykresach, liczba punktów pomiarowych ma znaczący wpływ na jakość interpolacji. W przypadku interpolacji wielomianowej Lagrange'a z równoodległymi węzłami, efekt Rungego jest bardzo widoczny już przy stosunkowo niewielkiej liczbie punktów pomiaru co ogranicza skuteczność tej metody. Zastosowanie węzłów Czebyszewa pozwala na uniknięcie efektu Rungego, jednakże interpolacja jest mniej dokładna niż w przypadku funkcji sklejanych oraz w przypadku zbyt dużej ilości punktów pomiarowych nadal może istnieć prawdopodobnieństwo wystąpienia efektu Rungego (co ciekawe podczas testów efekt ten nie występował przy 100 punktach pomiarowych). Najbardziej dokładna interpolacja została uzyskana przy użyciu funkcji sklejanych trzeciego stopnia.

#figure(
  image("../plots/quality-by-number-of-selection-points/chelm.png"),
  caption: "Wpływ ilości punktów pomiarowych na jakość interpolacji dla zestawu danych Chełm"
)

#figure(
  image("../plots/quality-by-number-of-selection-points/genoa_rapallo.png"),
  caption: "Wpływ ilości punktów pomiarowych na jakość interpolacji dla zestawu danych Genoa-Rapallo"
)

#pagebreak()

= Dokładniejsza analiza wyników interpolacji dla poszczególnych zestawów danych

W dalszej części raportu zostaną przedstawione bardziej szczegółowe analizy wyników interpolacji dla każdego z zestawów danych. Analizy te będą zawierały wykresy interpolacji dla różnych metod oraz różnych parametrów interpolacji.

== Zestaw danych Chełm

#figure(
  image("../plots/chelm/lagrange_linspace_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami zestawu danych Chełm"
)

Jak widać na przytoczonym wykresie interpolacja wielomianowa Lagrange'a z równoodległymi węzłami rozjeżdża się już przy ok. 20 punktach pomiaru przez działanie efektu Rungego.

#figure(
  image("../plots/chelm/lagrange_chebyshev_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa zestawu danych Chełm"
)

Zastosowanie węzłów Czebyszewa pozwala zazwyczaj na uniknięcie efektu Rungego, dzięki czemu interpolacja osiąga zadowalające wyniki już przy 50 punktach pomiaru. Niestety dla 103 punktów pomiarowych, interpolacja jest mniej dokładna niż w przypadku funkcji sklejanych, przez występujące na krańcach oscylacje.

#figure(
  image("../plots/chelm/cubic_spline.png", height: 300pt),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia zestawu danych Chełm"
)

Interpolacja funkcjami sklejanymi trzeciego stopnia pozwala na uzyskanie jeszcze lepszych wyników interpolacji, bez efektu Rungego, dzięki czemu nawet przy 52 punktach pomiaru interpolacja jest bardzo dokładna.

Podsumowując - w przypadku zestawu danych Chełm, interpolacja funkcjami sklejanymi trzeciego stopnia daje najlepsze wyniki, zarówno pod względem dokładności, jak i wydajności. Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa również daje zadowalające wyniki, jednakże jest mniej dokładna niż funkcje sklejane. Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami jest najmniej dokładna, a efekt Rungego jest bardzo widoczny już przy stosunkowo niewielkiej liczbie punktów pomiaru.

Żadnym zaskoczeniem nie jest fakt, że zwiększenie ilości punktów pomiarowych znacząco poprawia jakość interpolacji, jednakże w przypadku interpolacji wielomianowej z równoodległymi węzłami, zbyt duża liczba punktów może prowadzić do efektu Rungego, uniemożliwiając niekiedy poprawne odwzorowanie funkcji.

Rozłożenie punktów pomiarowych ma znaczący wpływ na jakość interpolacji, jednakże w przypadku interpolacji funkcjami sklejanymi trzeciego stopnia, rozmieszczenie punktów pomiarowych nie ma większego znaczenia, a interpolacja zawsze jest dokładna. W przypadku zestawu danych Chełm, łagość zmian wysokości pozwala na uzyskanie dokładnej interpolacji nawet przy niewielkiej liczbie punktów pomiarowych kosztem pewnego uproszczenia profilu terenu.

#pagebreak()

== Zestaw danych Genoa-Rapallo

#figure(
  image("../plots/genoa_rapallo/lagrange_linspace_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami zestawu danych Genoa-Rapallo"
)

Jak widać na przytoczonym wykresie interpolacja wielomianowa Lagrange'a z równoodległymi węzłami nie radzi sobie z gwałtownymi zmianami wysokości, dając niezadowalające wyniki interpolacji.

#figure(
  image("../plots/genoa_rapallo/lagrange_chebyshev_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa zestawu danych Genoa-Rapallo"
)

Niestety z uwagi na profil terenu i gwałtowne zmiany wysokości, interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa również daje niezadowalające wyniki. Widać oscylację na końcu profilu terenu, uwagi na duża liczbę gwałtownych zmian wysokości. Najlepszy wynik (choć nadal niezadowalający) metoda dała przy 52 punktach pomiarowych.

#figure(
  image("../plots/genoa_rapallo/cubic_spline.png", height: 300pt),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia zestawu danych Genoa-Rapallo"
)

Interpolacja funkcjami sklejanymi trzeciego stopnia daje znacznie lepsze wyniki. Profil terenu jest dokładniejszy, a gwałtowne zmiany wysokości nie wpływają na jakość interpolacji. Niestety z uwagi na trudne warunki terenowe, interpolacja nie jest idealna, jednakże jest znacznie lepsza niż w przypadku interpolacji wielomianowej. Funkcja przypomina oryginalną, jednakże widać pominięcie minimum lokalnych i pominięcie gwałtownych wahań wysokości.

== Zestaw danych HelYeah

#figure(
  image("../plots/hel_yeah/lagrange_linspace_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami zestawu danych HelYeah"
)

Podobnie jak w przypadku zestawu danych Genoa-Rapallo, interpolacja wielomianowa Lagrange'a z równoodległymi węzłami nie radzi sobie z gwałtownymi zmianami wysokości, dając niezadowalające wyniki interpolacji.

#figure(
  image("../plots/hel_yeah/lagrange_chebyshev_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa zestawu danych HelYeah"
)

Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa również daje niezadowalające wyniki. Widać oscylację na końcu profilu terenu, uwagi na duża liczbę gwałtownych zmian wysokości. Najlepszy wynik (choć nadal niezadowalający) metoda dała przy 52 punktach pomiarowych, kosztem pominięcia gwałtownych zmian wysokości w końcowej części funkcji.

#figure(
  image("../plots/hel_yeah/cubic_spline.png", height: 300pt),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia zestawu danych HelYeah"
)

Najlepszy wynik znowu daje interpolacja funkcjami sklejanymi trzeciego stopnia. Profil terenu jest dokładniejszy, a gwałtowne zmiany wysokości nie wpływają na jakość interpolacji. Niestety z uwagi na trudne warunki terenowe, interpolacja nie jest idealna, jednakże jest znacznie lepsza niż w przypadku interpolacji wielomianowej.

#pagebreak()

== Zestaw danych Stale

#figure(
  image("../plots/stale/lagrange_linspace_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami zestawu danych Stale"
)

Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami daje zadowalające wyniki dla niskiej ilości punktów pomiarowych, jednakże przez efekt Rungego interpolacja rozjeżda się już przy 11 punktach pomiarowych.

#figure(
  image("../plots/stale/lagrange_chebyshev_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa zestawu danych Stale"
)

Zastosowanie węzłów Czebyszewa pozwala na uniknięcie efektu Rungego, dzięki czemu interpolacja osiąga zadowalające wyniki, pomijając wynik dla 103 punktów pomiarowych, gdzie występują oscylacje na krańcach profilu terenu.

#figure(
  image("../plots/stale/cubic_spline.png", height: 300pt),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia zestawu danych Stale"
)

Interpolacja funkcjami sklejanymi trzeciego stopnia pozwala na uzyskanie równie dobrych wyników, co w przypadku interpolacji wielomianowej Lagrange'a z węzłami Czebyszewa. Interpolacja jest dokładna, chociaż kosztem dłuższego czasu obliczeń niż w przypadku interpolacji wielomianowej dając ten sam doskonały wynik.

W przypadku tak prostych funkcji terenu, interpolacja funkcjami sklejanymi trzeciego stopnia nie jest konieczna i interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa daje równie dobre wyniki, jednakże jest to znacznie bardziej pewna metoda.

== Zestaw danych Wielki Kanion

#figure(
  image("../plots/wielki_kanion/lagrange_linspace_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami zestawu danych Wielki Kanion"
)

Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami znowu daje niezadowalające wyniki. Widać efekt Rungego, który uniemożliwia poprawne odwzorowanie funkcji terenu.

#figure(
  image("../plots/wielki_kanion/lagrange_chebyshev_nodes.png", height: 300pt),
  caption: "Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa zestawu danych Wielki Kanion"
)

Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa również daje niezadowalające wyniki. Najlepszy wynik (choć znacznie upraszczając profil terenu) metoda dała przy 52 punktach pomiarowych. Niestety widać efekt Rungego na krańcach profilu terenu przy 103 punktach pomiarowych.

#figure(
  image("../plots/wielki_kanion/cubic_spline.png", height: 300pt),
  caption: "Interpolacja funkcjami sklejanymi trzeciego stopnia zestawu danych Wielki Kanion"
)

Interpolacja funkcjami sklejanymi trzeciego stopnia daje najlepsze wyniki. Profil terenu jest dokładniejszy, a gwałtowne zmiany wysokości nie wpływają na jakość interpolacji. Z uwagi na warunki terenowe pominięte zostały małe wypukłości na profilu terenu, jednakże poza tym interpolacja jest dokładna.

= Podsumowanie

W ramach projektu zaimplementowano dwie metody interpolacji funkcji - wielomianową Lagrange'a oraz funkcjami sklejanymi trzeciego stopnia. Obie metody zostały przetestowane na 5 różnych zestawach danych o różnych cechach, w celu zbadania zachowania obu metod w różnych warunkach.

Wyniki pokazują, że interpolacja funkcjami sklejanymi trzeciego stopnia daje najlepsze wyniki, zarówno pod względem dokładności, jak i wydajności. Metoda ta pozwala na uzyskanie najlepszej interpolacji w każdych warunkach. Mimo, iż metoda ta upraszcza profil terenu w przypadku bardziej skomplikowanych funkcji, to jest to zazwyczaj niezauważalne dla użytkownika. Metoda ta nie ma efektu Rungego, co pozwala na uzyskanie dokładnej interpolacji przy mniejszej liczbie punktów pomiarowych niż w przypadku interpolacji wielomianowej.

Interpolacja wielomianowa Lagrange'a z węzłami Czebyszewa również daje zadowalające wyniki. Jest ona mniej dokładna niż funkcje sklejane, lecz w przypadku prostych funkcji terenu, daje równie dobre wyniki. Z nieznanej przyczyny, w przypadku testów, efekt Rungego występował przy 103 punktach pomiarowych, co jest zaskakujące z uwagi na brak tego efektu przy np. 100 punktach pomiarowych.

Interpolacja wielomianowa Lagrange'a z równoodległymi węzłami jest najmniej dokładna, a efekt Rungego jest bardzo widoczny już przy stosunkowo niewielkiej liczbie punktów pomiaru co ogranicza skuteczność tej metody. Metoda ta może być stosowana jedynie w przypadku najprostszych funkcji terenu o małej liczbie punktów pomiarowych.