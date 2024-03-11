#set page(
  paper: "a4",
  numbering: "1 / 1",
)

#show ref: it => {
  set text(fill: blue);
  underline(it)
}

#set ref(supplement: it => {
  it.supplement.text.replace("Table", "Tabela")
})

#show figure.caption: it => [
  #if it.supplement == [Figure] [
    Rysunek  #it.counter.display()#it.separator #it.body
  ] else if it.supplement == [Table] [
    Tabela  #it.counter.display()#it.separator #it.body
  ] else [
    #it.supplement #it.numbering#it.separator #it.body
  ]
]

#align(center)[
  = Analiza wskaźnika giełdowego MACD
  #stack(
    dir: ttb,
    spacing: 5pt,
    block()[Autor: Stanisław Nieradko (193044)],
    block()[09.03.2024]
  )
]

== 1. Wstęp teoretyczny

Wskaźnik ruchomej średniej zbieżnej i zbieżnej ruchomej różnicy (MACD) jest jednym z najpopularniejszych i wszechstronnych narzędzi analizy technicznej wykorzystywanych przez inwestorów na rynkach finansowych. Stworzony przez Geralda Appela w latach 70. XX wieku, MACD jest używany do identyfikowania potencjalnych punktów wejścia i wyjścia na rynku, oceny siły trendu oraz potwierdzania odwróceń trendów.

Centralnym założeniem wskaźnika MACD jest porównywanie dwóch wykładniczych średnich ruchomych, zazwyczaj o różnych okresach, w celu wydobycia sygnałów dotyczących zmian w momencie trendu cenowego. Jest to proces oparty na obserwacji dynamiki cen – różnicy między średnią krótkoterminową a długoterminową – co pozwala na wykrycie momentów, w których ruch cenowy zyskuje na sile lub słabnie.

Podstawowym elementem wskaźnika MACD jest linia MACD, która powstaje przez odejmowanie długoterminowej średniej ruchomej od krótkoterminowej średniej ruchomej. Wynik tego odejmowania stanowi wartość wykładniczej średniej ruchomej różnicy. Ponadto, często stosuje się linie sygnałowe, które są kolejnymi wykładniczymi średnimi ruchomymi uzyskanymi z linii MACD. Te dwie linie, MACD i linia sygnałowa, krzyżują się między sobą, co generuje sygnały kupna i sprzedaży.

Analiza wskaźnika MACD jest stosunkowo prostym procesem, jednak jego interpretacja wymaga pewnego stopnia zrozumienia rynków finansowych i zachowań cenowych. Inwestorzy często wykorzystują dodatkowe narzędzia i strategie w połączeniu z MACD, aby zwiększyć trafność swoich decyzji inwestycyjnych.

== 2. Dane testowe i Implementacja

Zaimplementowany wskaźnik MACD ma poniższy wzór:

$ "MACD" = "EMA"_12 - "EMA"_26 $

$ "SIGNAL" = "EMA"_"9 z MACD" $

i korzysta z niżej podanego wzoru na wykładniczą średnią kroczącą (EMA):

$ "EMA"_n = frac(p_0 + (1 - alpha)p_1 + (a - alpha)^2p_2 + ... + (1-alpha)^N p_N, 1 + (1 - alpha) + (1 - alpha)^2 + ... + (a - alpha)^N) $

$ p_i op("jest próbką z") i op("-tego dnia, ") p_0 op("jest próbką z aktualnego dnia, ") p_N op("- to próbka sprzed ") N op("dni")$

$ alpha = 2/(N + 1)$

$ N - op("liczba okresów")$

Wskaźnik został zaimplementowany w języku Python z wykorzystaniem bibliotek _pandas_ oraz _matplotlib_ oraz narzędzia Jupyter Notebook pozwalającego na lepszą wizualiację wyników analiz.

Do analizy wskaźnika MACD wykorzystano historyczne notowania spółki CD Projekt S.A. od początku powstania spółki do 27.02.2024 r. oraz kurs walutowy EURO/PLN od 24.09.1984 r. do 08.03.2024 r. Dane te zostały pobrane z serwisu stooq.pl w formacie CSV, wykorzstane w całości do obliczenia wskaźnika MACD oraz częściowo do generowania wykresów oraz symulowania zyskowności wskaźnika dla okresu 01.01.2020 r. - 27.09.2022 r (1000 dni).

== 3. Analiza notowań i wskaźnika MACD

=== 3.1. CD Projekt S.A.

#figure(
  image("cdp-normal.png"),
  caption: [
    Wykres cen akcji CD Projekt S.A. w okresie 01.01.2020 - 27.09.2022
  ]
)

Wykres cen akcji CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r. przedstawia duże wahania cen akcji. Łatwo zauważalny jest ogólny spadek wartości spółki w okolicach grudnia 2020 kiedy to premierę miał będący spektakularną klapą Cyberpunk 2077 oraz ciągły wpływ pandemii na rynek gier komputerowych. Warto zauważyć również, że w okresie od marca 2021 r. do września 2022 r. cena akcji CD Projekt S.A. systematycznie spadała.

#figure(
  image("cdp-macd.png"),
  caption: [
    Wykres wskaźnika MACD dla notowań CD Projekt S.A. w okresie 01.01.2020 - 27.09.2022
  ]
)

Wykres prezentuje wartości wskaźnika MACD dla notowań CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r. Miejsca przecięcia się linii MACD oraz SIGNAL oznaczone są dodatkowo zielonymi strzałkami w górę w przypadku sygnału kupna (BUY) oraz czerwonymi strzałkami w dół w przypadku sygnału sprzedaży (SELL).

#figure(
  image("cdp-normal-buy-sell.png"),
  caption: [
    Wykres cen akcji CD Projekt S.A. w okresie 01.01.2020 - 27.09.2022 z zaznaczonymi momentami kupna i sprzedaży akcji z wykorzystaniem wskaźnika MACD.
  ]
)

Ostatni wykres prezentuje sygnały kupna (BUY) oraz sprzedaży (SELL) nałożone na wykres cen akcji CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r. Widać, że wskaźnik nie nadążał z generowaniem sygnału w mocno chaotycznych okresach (np. w grudniu 2020 r.) co skutkowało dużymi stratami w tym okresie. W późniejszym okresie w czasie ogólnego spadku wartości akcji wskaźnik ten przynosił regularne straty lub miminalne zyski.

=== 3.2 EURO/PLN

#figure(
  image("eurpln-normal.png"),
  caption: [
    Wykres kursu walutowego EURO/PLN w okresie 01.01.2020 - 27.09.2022
  ]
)

Wykres kursu walutowego EURO/PLN w okresie 01.01.2020 r. - 27.09.2022 r. przedstawia stosunkowo spokojny wzrost wartości EURO względem PLN. Mimo dwóch okresów o dynamicznym wzroście wartości EURO (okolice marca 2020 oraz marca 2022) w ogólnym rozrachunku wartość waluty względem PLN zmianiała się stabilnie.

#figure(
  image("eurpln-macd.png"),
  caption: [
    Wykres wskaźnika MACD dla kursu walutowego EURO/PLN w okresie 01.01.2020 - 27.09.2022
  ]
)

Wykres prezentuje wartości wskaźnika MACD dla kursu walutowego EURO/PLN w okresie 01.01.2020 r. - 27.09.2022 r. Miejsca przecięcia się linii MACD oraz SIGNAL oznaczone są dodatkowo zielonymi strzałkami w górę w przypadku sygnału kupna (BUY) oraz czerwonymi strzałkami w dół w przypadku sygnału sprzedaży (SELL).

#figure(
  image("eurpln-normal-buy-sell.png"),
  caption: [
    Wykres kursu walutowego EURO/PLN w okresie 01.01.2020 - 27.09.2022 z zaznaczonymi momentami kupna i sprzedaży waluty z wykorzystaniem wskaźnika MACD.
  ]
)

W przypadku kursu walutowego EURO/PLN wskaźnik MACD działał lepiej niż w przypadku akcji CD Projekt S.A. Wskaźnik ten poprawnie wskazywał najlepsze momenty na zakup i sprzedaż waluty. W okresach dużych wahań cen wskaźnik ten nie radził sobie tak dobrze jak w przypadku spokojnych okresów (można zauważyć duży zarobek w momencie gwałtownych skoków ceny EURO), aczkolwiek w długim okresie czasu przyniósł on zyski dzięki ogólnemu "spokojowi" tego instrumentu finansowego.


== 4. Algorytm

=== 4.1 Algorytm prosty

Wykorzystajmy wskaźnik MACD do stworzenia prostego algorytmu symulującego inwestowanie w instrument finansowy naszego wyboru. Po podaniu mu historycznych danych instrumentu oraz ilości posiadanych aktyw.

Algorytm ten kupuje i sprzedaje maksymalną liczbę akcji jaką jest w stanie w momencie przecięcia się MACD i SIGNAL, oraz gdy okres symulacji następuje końca sprzedaje wszystkie posiadane akcje / waluty po cenie rynkowej ostatniego dnia symulacji. Algorytm zwraca zysk bądź stratę w porównaniu do sytuacji kiedy natychmiast sprzedalibyśmy wszystkie startowe aktywa po cenie w dniu rozpoczęcia symulacji. Ceną dla każdego dnia jest kwota zamknięcia.

W przypadku notowań CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r. sygnały kupna i sprzedaży generowane przez wskaźnik MACD wykorzystane przyniosły *stratę* w wyskości *2366.70 PLN*. Wskaźnik MACD największe straty przyniósł w okresie września i października 2020 [@cdp-sells] prawdopodobnie z powodu dużych wahań cen akcji CD Projekt S.A. w tym okresie. Z drugiej strony wskaźnik MACD przynosił zyski w okresie niewielkich wahań cen akcji, np. na początku 2020 r.

W przypadku kursu walutowego EURO/PLN w okresie 01.01.2020 r. - 27.09.2022 r. sygnały kupna i sprzedaży generowane przez wskaźnik MACD przyniosły *zysk* w wyskości *774.62 PLN*. Dzięki zdecydowanie większej stabilności kursu w porównaniu do kursu akcji CD Projekt S.A. wskaźnik MACD przyniósł zyski w większości przypadków nie ponosząc większych strat podczas sprzedaży [@eurpln-sells].

Okazuje się że najprosztsza implementacja algorytmu korzystająca ze wskaźnika MACD działa zbyt wolno by pozwolić nam na inwestowanie w aktywa szybko zmieniające swoją wartość na giełdzie, ale świetnie nadaje się do inwestycji w bardziej stabilne instrumenty typu waluty.

=== 4.2 Potencjalne ulepszenie algorytmu

Próbując udoskonalić podstawowy algorytm udało mi się znaleźć potencjalne ulepszenie. Dzięki dodaniu nowego warunku do naszego algorytmu aby dodkonywał on zakupu akcji tylko i wyłacznie wtedy kiedy przez co najmniej x ostatnich dni wskaźnik MACD nie przecinał się z SIGNAL. Dzięki ustawieniu parametru x na 2 dni [@cdp-x], udało mi się zwiększyć zysk z inwestycji w akcje CD Projekt S.A. o 6520 PLN. W przypadku inwestycji w walutę EURO/PLN najlepszy zysk udało się uzyskać dla x = 0 [@europln-x].

Podczas analizy tego rozwiązania udało mi się ustalić że zastosowanie takiego algorytmu poprawia wyniki inwestycji w 15 okresach na sprawdzone 21 (każdy okres ma 1000 dni i rozpoczyna się w roku z tabeli) [@eurpln-improved] w przypadku inwestycji w walutę EURO/PLN oraz w 14 okresach na 21 [@cdp-improved] w przypadku inwestycji w akcje CD Projekt S.A.

W podsumowaniu ogólnym algorytm ten przynosi straty w porównaniu do jego prostszej wersji, aczkolwiek w niektórych latach przynosi on znaczące zyski.

== 5. Wnioski

W przypadku akcji CD Projekt RED S.A. wskaźnik MACD nie był w stanie przewidzieć i zaregować na gwałtowne spadki wartości cen akcji spowodowanych decyzjami biznesowymi. Najbardziej widoczne jest to w okresie grudnia 2020, kiedy wskaźnikowi nieudało się zareagowoać w porę na gwałtowny spadek cen akcji i zarekomendował on sprzedaż akcji już po spadku poniżej ceny zakupu. Podobną sytuację możemy zauważyć w styczniu 2021, kiedy to akcje gwałtownie wystrzeliły w górę i była szansa na spory zysk, ale wskaźnik zarekomendował sprzedaż dopiero po jego spadnięciu. Podobne sytuacje można zaobserować w cały okresie od maja 2021 do końca analizowanych danych, co wskazuje na słabość wskaźnika wobec gwałtownych zmian.

Ta sama sytacja występuje w przypadku kursu EURO, aczkolwiek z uwagi na ogólny wzrost wartości waluty przez cały badany okres oraz powolne zmiany wartości udało się wskaźnikowi uzyskać zysk dla obu algorytmów.


== 6. Podsumowanie

Wskaźnik MACD działa dobrze w przypadku inwestycji w aktywa długoterminowe jak waluty. W przypadku inwestycji w akcje oraz towary o zmiennej cenie nie nadąża on za rynkiem i przynosi straty. Ulepszenie algorytmu poprawia wyniki inwestycji w akcje oraz towary w niektórych latach, ale nadal przynosi straty w ogólnym rozrachunku.

MACD jest zdecydowanie wskaźnikiem długoterminowym, który nie nadaje się do inwestycji krótkoterminowych aczkolwiek może on być bardzo przydatny w analizie technicznej aktywa z uwagi na ogólną poprawność (pomijając grę krótkoterminową). W obu przykładach wskaźnik ten poprawnie wskazywał najlepsze momenty na zakup i sprzedaż instrumentów finansowych podczas spokojnych okresów na rynku. 

#pagebreak()

== 7. Uzupełnienie

#let results = csv("cdp-sells.csv")

#set text(size: 9pt)

#figure(
  table(
    columns: 4,
    ..results.flatten()
  ),
  caption: [
    Tabela sprzedaży akcji CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r. wraz z zyskiem/stratą przy zastosowaniu prostego algorytmu symulacyjnego.
  ]
) <cdp-sells>

#set text(size: 11pt)

#let results = csv("eurpln-sells.csv")

#set text(size: 9pt)

#figure(
  table(
    columns: 4,
    ..results.flatten()
  ),
  caption: [
    Tabela sprzedaży euro w okresie 01.01.2020 r. - 27.09.2022 r. wraz z zyskiem/stratą przy zastosowaniu prostego algorytmu symulacyjnego.
  ]
) <eurpln-sells>

#set text(size: 11pt)

#let results = csv("x_parameter_cdp.csv")

#set text(size: 9pt)

#figure(
  table(
    columns: 4,
    ..results.flatten()
  ),
  caption: [
    Tabela zysku/straty w zależności od parametru x dla akcji CD Projekt S.A.
  ]
) <cdp-x>

#set text(size: 11pt)

#let results = csv("x_parameter_eurpln.csv")

#set text(size: 9pt)

#figure(
  table(
    columns: 4,
    ..results.flatten()
  ),
  caption: [
    Tabela zysku/straty w zależności od parametru x dla waluty EURO/PLN.
  ]
) <europln-x>

#set text(size: 11pt)

#let results = csv("cdp_improved.csv")

#set text(size: 9pt)

#figure(
  table(
    columns: 5,
    ..results.flatten()
  ),
  caption: [
    Tabla z porównaniem zysku / straty dla różnych lat po zastosowaniu prostego i ulepszonego algorytmu dla akcji CD Projekt S.A.
  ]
) <cdp-improved>

#set text(size: 11pt)

#let results = csv("eurpln_improved.csv")

#set text(size: 9pt)

#figure(
  table(
    columns: 5,
    ..results.flatten()
  ),
  caption: [
    Tabla z porównaniem zysku / straty dla różnych lat po zastosowaniu prostego i ulepszonego algorytmu dla waluty EURO/PLN.
  ]
) <eurpln-improved>

#set text(size: 11pt)