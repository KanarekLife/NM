#set page(
  paper: "a4",
  margin: 1cm
)

#align(center)[
  = Analiza wskaźnika giełdowego MACD
  Autor: Stanisław Nieradko
]

== 1. Wstęp teoretyczny

Wskaźnik giełdowy MACD (Moving Average Convergence Divergence) jest jednym z najpopularniejszych narzędzi analizy technicznej wykorzystywanych na rynkach finansowych. Służy do identyfikacji trendów oraz generowania sygnałów kupna i sprzedaży. MACD składa się z dwóch linii: linii MACD i linii sygnałowej. Linia MACD obliczana jest jako różnica między dwiema wykładniczymi średnimi kroczącymi (EMA) o różnych okresach, natomiast linia sygnałowa to wygładzona średnia krocząca linii MACD. Krzyżowanie się tych dwóch linii generuje sygnały kupna i sprzedaży. Wskaźnik MACD jest używany zarówno przez traderów krótkoterminowych, jak i inwestorów długoterminowych.

Wskaźnik MACD został zaimplementowany w języku Python z wykorzystaniem biblioteki pandas. Implementacja korzysta z niżej podanego wzoru na wykładniczą średnią kroczącą (EMA):

$ "EMA"_n = frac(p_0 + (1 - alpha)p_1 + (a - alpha)^2p_2 + ... + (1-alpha)^N p_N, 1 + (1 - alpha) + (1 - alpha)^2 + ... + (a - alpha)^N) $

$ p_i op("jest próbką z") i op("-tego dnia, ") p_0 op("jest próbką z aktualnego dnia, ") p_N op("- to próbka sprzed ") N op("dni")$

$ alpha = 2/(N + 1)$

$ N - op("liczba okresów")$

== 2. Dane testowe

Do analizy wskaźnika MACD wykorzystano historyczne notowania spółki CD Projekt S.A. od początku powstania spółki do 27.02.2024 r. oraz kurs walutowy EURO/PLN od 24.09.1984 r. do 08.03.2024 r. Dane te zostały pobrane z serwisu stooq.pl w formacie CSV, wykorzstane w całości do obliczenia wskaźnika MACD oraz częściowo do generowania wykresów oraz symulowania zyskowności wskaźnika dla okresu 01.01.2020 r. - 27.09.2022 r (1000 dni).

== 3. Analiza notowań i wskaźnika MACD

=== 3.1. CD Projekt S.A.

#figure(
  image("cdp-normal.png"),
  caption: [
    Wykres cen akcji CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r.
  ]
)

#figure(
  image("cdp-macd.png"),
  caption: [
    Wykres wskaźnika MACD dla notowań CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r.
  ]
)

#figure(
  image("cdp-normal-buy-sell.png"),
  caption: [
    Wykres cen akcji CD Projekt S.A. w okresie 01.01.2020 r. - 27.09.2022 r. z zaznaczonymi momentami kupna i sprzedaży akcji z wykorzystaniem wskaźnika MACD.
  ]
)

Jak widać na załączonych wykresach, wskaźnik MACD nie potrafił sobie poradzić z dużymi wahaniami cen akcji CD Projekt S.A. w okolicach października 2020 oraz podczas systematycznego spadku cen akcji CDP w okresie od marca 2021. MACD poprawnie reagował na spadki, aczkolwiek reagował on ze spóźnieniem, przez co nie był w stanie zabezpieczyć inwestycji przed stratami.


=== 3.2 EURO/PLN

#figure(
  image("eurpln-normal.png"),
  caption: [
    Wykres kursu walutowego EURO/PLN w okresie 01.01.2020 r. - 27.09.2022 r.
  ]
)

#figure(
  image("eurpln-macd.png"),
  caption: [
    Wykres wskaźnika MACD dla kursu walutowego EURO/PLN w okresie 01.01.2020 r. - 27.09.2022 r.
  ]
)

#figure(
  image("eurpln-normal-buy-sell.png"),
  caption: [
    Wykres kursu walutowego EURO/PLN w okresie 01.01.2020 r. - 27.09.2022 r. z zaznaczonymi momentami kupna i sprzedaży waluty z wykorzystaniem wskaźnika MACD.
  ]
)

W przypadku kursu walutowego EURO/PLN wskaźnik MACD działał lepiej niż w przypadku akcji CD Projekt S.A. Wskaźnik ten poprawnie wskazywał najlepsze momenty na zakup i sprzedaż waluty podczas spokojnych okresów na rynku. W okresach dużych wahań cen wskaźnik ten nie radził sobie tak dobrze jak w przypadku spokojnych okresów, aczkolwiek w długim okresie czasu przyniósł on zyski dzięki ogólnemu "spokojowi" tego instrumentu finansowego.


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

W podsumowaniu ogólnym algorytm ten przynosi straty w porównaniu do jego prostszej wersji, aczkolwiek dla niektórych lat przynosi on znaczące zyski.

== 5. Podsumowanie

Wskaźnik MACD działa dobrze w przypadku inwestycji w aktywa długoterminowe jak waluty bądź (prawdopodobnie) złoto. W przypadku inwestycji w akcje oraz towary o zmiennej cenie nie nadąża on za rynkiem i przynosi straty. Ulepszenie algorytmu poprawia wyniki inwestycji w akcje oraz towary w niektórych latach, ale nadal przynosi straty w ogólnym rozrachunku.

MACD jest zdecydowanie wskaźnikiem długoterminowym, który nie nadaje się do inwestycji krótkoterminowych aczkolwiek może on być bardzo przydatny w analizie technicznej aktywa z uwagi na ogólną poprawność (pomijając grę krótkoterminową). W obu przykładach wskaźnik ten poprawnie wskazywał najlepsze momenty na zakup i sprzedaż instrumentów finansowych podczas spokojnych okresów na rynku. 

#pagebreak()

== 6. Uzupełnienie

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