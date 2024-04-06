#let creationDate = datetime(year: 2024, month: 04, day: 02)

#set document(
  title: "Metody Numeryczne - Projekt 2: Układy równań liniowych",
  author: "Stanisław Nieradko 193044 <stanislaw@nieradko.com>",
  date: creationDate
)

#set page(
  paper: "a4",
  margin: (x: 1cm, y: 1cm),
  numbering: "1/1",
  footer: context [
    #set text(size: 9pt)
    *Układy równań liniowych* Stanisław Nieradko 193044
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
    text(size: 24pt, weight: "semibold")[Układy równań liniowych],
    v(10pt),
    text(size: 14pt)[Metody Numeryczne - Projekt 2],
    v(20pt),
    text(size: 12pt)[Stanisław Nieradko 193044],
    v(10pt),
    text(size: 12pt)[#creationDate.display()]
  )
]

#v(10pt)

#outline(
  title: "Spis treści",
)

#v(10pt)

= 1. Wstęp <Wstęp>

Celem projektu jest zaimplementowanie i porównanie iteracyjnych metod rozwiązywania układów równań liniowych oraz metody faktoryzacji LU. 
  
W ramach projektu zaimplementowane zostaną metody Jacobiego i Gaussa-Seidela, a także metoda faktoryzacji LU bez wykorzystania zewnętrznych bibliotek do obliczeń macierzowych. 
  
Następnie zostaną przeprowadzone testy wydajnościowe, które pozwolą na porównanie czasu wyznaczenia rozwiązań układów równań liniowych w zależności od zastosowanej metody.

Do zrealizowania zadania wykorzystany zostanie język programowania Python, środowisko Jupyter Notebook oraz biblioteka Matplotlib do wizualizacji wyników. Wszelkie operacje na macierzach będą wykonywane przy użyciu własnoręcznie napisanej klasy `Matrix`.

Zgodnie z treścią #underline[Zadania A] na początku projektu utworzony został układ równań liniowych reprezentowany przez macierze $A$ i $B$. 

Macierz $A$ jest macierz pasmową kwadratową o wymiarach $N #sym.times N$ dla $N = 9 c d = 944$, $a_1 = 5 + 3 = 5$, $a_2 = a_3 = -1$. Wartości $a_i$ indukują wartości przekątnych o przesunięciu względem głównej przekątnej macierzy $op("offset") = i - 1$ (także $a_1$ to główna przekątna, $a_2$ to przekątne przesunięte o 1 względem głównej przekątnej itd.). Mamy też wektor $B$ o długości $N$, którego $n$-ty element jest równy $sin(n #sym.dot (f + 1)) = sin(n)$

$ A = mat(5, -1, -1, 0, 0, dots.h, 0, 0, 0, 0, 0;
          -1, 5, -1, -1, 0, dots.h, 0, 0, 0, 0, 0;
          -1, -1, 5, -1, -1, dots.h, 0, 0, 0, 0, 0;
          0, -1, -1, 5, -1, dots.h, 0, 0, 0, 0, 0;
          0, 0, -1, -1, 5, dots.h, 0, 0, 0, 0, 0;
          dots.v, dots.v, dots.v, dots.v, dots.v, dots.down, dots.v, dots.v, dots.v, dots.v, dots.v;
          0, 0, 0, 0, 0, dots.h, 5, -1, -1, 0, 0;
          0, 0, 0, 0, 0, dots.h, -1, 5, -1, -1, 0;
          0, 0, 0, 0, 0, dots.h, -1, -1, 5, -1, -1;
          0, 0, 0, 0, 0, dots.h, 0, -1, -1, 5, -1;
          0, 0, 0, 0, 0, dots.h, 0, 0, -1, -1, 5;
          )
  op(#h(10pt))
  B = mat(-0.7568;
          0.9894;
          -0.5366;
          -0.2879;
          0.9129;
          dots.v;
          0.4675;
          0.3635;
          -0.9426;
          0.8688;
          -0.1931;
          ) $

#pagebreak()

= 2. Porównanie metod rozwiązywania układów równań liniowych dla domyślnego układu równań

W ramach #underline[Zadania B] zaimplementowane zostały metody Jacobiego i Gaussa-Seidela, które posłużyły do rozwiązania układu równań liniowych zdefiniowanego we #link(<Wstęp>)[wstępie].

#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    table.header(
      text(size: 12pt, weight: "semibold")[Metoda],
      text(size: 12pt, weight: "semibold")[Liczba iteracji],
      text(size: 12pt, weight: "semibold")[Czas obliczeń [s]],
      text(size: 12pt, weight: "semibold")[Błąd]
    ),
    text[Jacobi], text[67], text[11.7006], text[8.830506921606741e-10],
    text[Gauss-Seidel], text[39], text[6.4401], text[8.212466420029578e-10],
    text[Faktoryzacja LU], text[-], text[35.8186], text[1.9124294068938155e-15]
  ),
  caption: [Porównanie metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla domyślnego układu równań]
)

Dla podanego układu równań liniowych metoda Jacobiego wymagała 67 iteracji, a Gaussa-Seidela 39 iteracji, co wskazuje na to, że metoda Gaussa-Seidela jest szybsza od metody Jacobiego (6.44 s vs 11.70 s). Błąd obliczeń jest na bardzo podobnym poziomie dla obu metod z delikatnym zwycięstwem metody Gaussa-Seidela.

#figure(
  image("../dist/jacobi-gauss-seidel-default-comparison.svg"),
  caption: [Porównanie normy residuum w zależności od iteracji dla metod Jacobiego i Gaussa-Seidela]
)

= 3. Porównanie metod rozwiązywania układów równań liniowych dla alternatywnego układu równań

W ramach #underline[Zadania C] i #underline[Zadanie D] wygenerowano alternatywny układ równań liniowych, który różni się od domyślnego układu równań liniowych z #link(<Wstęp>)[wstępu] jedynie wartościami elementów macierzy $A$. Jedyną zmianą były wartości głównej diagonalnej na $a_1 = 3$.

$ A = mat(3, -1, -1, 0, 0, dots.h, 0, 0, 0, 0, 0;
      -1, 3, -1, -1, 0, dots.h, 0, 0, 0, 0, 0;
      -1, -1, 3, -1, -1, dots.h, 0, 0, 0, 0, 0;
      0, -1, -1, 3, -1, dots.h, 0, 0, 0, 0, 0;
      0, 0, -1, -1, 3, dots.h, 0, 0, 0, 0, 0;
      dots.v, dots.v, dots.v, dots.v, dots.v, dots.down, dots.v, dots.v, dots.v, dots.v, dots.v;
      0, 0, 0, 0, 0, dots.h, 3, -1, -1, 0, 0;
      0, 0, 0, 0, 0, dots.h, -1, 3, -1, -1, 0;
      0, 0, 0, 0, 0, dots.h, -1, -1, 3, -1, -1;
      0, 0, 0, 0, 0, dots.h, 0, -1, -1, 3, -1;
      0, 0, 0, 0, 0, dots.h, 0, 0, -1, -1, 3;
      )
  op(#h(10pt))
  B = mat(-0.7568;
          0.9894;
          -0.5366;
          -0.2879;
          0.9129;
          dots.v;
          0.4675;
          0.3635;
          -0.9426;
          0.8688;
          -0.1931;
          ) $

#pagebreak()

Dla takich danych poszczególne metody rozwiązywania układów równań liniowych osiągnęły następujące wyniki:

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    table.header(
      text(size: 12pt, weight: "semibold")[Metoda],
      text(size: 12pt, weight: "semibold")[Liczba iteracji],
      text(size: 12pt, weight: "semibold")[Czas obliczeń [s]],
      text(size: 12pt, weight: "semibold")[Błąd],
      text(size: 12pt, weight: "semibold")[Najmniejszy błąd (iteracja)]
    ),
    text[Jacobi], text[93], text[16.5827], text[894576398.9636], text[0.18136286954970482 (9)],
    text[Gauss-Seidel], text[36], text[6.3301], text[596229785.312], text[0.28223629372829717 (3)],
    text[Faktoryzacja LU], text[-], text[30.2689], text[6.13589416330441e-13], text[-],
  ),
  caption: [Porównanie metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla alternatywnego układu równań]
)

#figure(
  image("../dist/jacobi-gauss-seidel-alternative-comparison.svg"),
  caption: [Porównanie normy residuum w zależności od iteracji dla metod Jacobiego i Gaussa-Seidela dla alternatywnego układu równań]
) <PorównanieIteracyjnychMetodRozwiązywaniaAlternatywnegoUkładuRównańLiniowych>

Niestety dla alternatywnego układu równań liniowych zarówno metoda Jacobiego jak i metoda Gaussa-Seidela nie były w stanie znaleźć poprawnego rozwiązania. Błąd obliczeń dla obu metod rośnie od odpowiednio 9 i 3 iteracji (osiągając błąd na poziomie $10^(-1)$), co wskazuje na to, że metody te nie są zbieżne dla tego układu równań. W przypadku metody Gaussa-Seidela błąd wzrasta zdecydowanie szybciej, co widać na #link(<PorównanieIteracyjnychMetodRozwiązywaniaAlternatywnegoUkładuRównańLiniowych>)[wykresie normy residuum w zależności od iteracji].

W przypadku metody faktoryzacji LU błąd obliczeń jest na poziomie $6.13589416330441e-13$, co wskazuje na to, że metoda ta jest bardzo dokładna dla tego układu równań kosztem czasu obliczeń.

= 4. Czas obliczeń w zależności od rozmiaru macierzy

W ramach #underline[Zadania E] przeprowadzono testy wydajnościowe dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla układów równań liniowych o różnych rozmiarach.

Testy wydajnościowe przeprowadzono dla macierzy kwadratowych o rozmiarach $N = {100, 500, 1000, 2000, 3000}$. Dla każdego rozmiaru macierzy wygenerowano układ równań liniowych zgodnie z #link(<Wstęp>)[wstępem].

#figure(
  image("../dist/jacobi-gauss-seidel-lu-time-comparison.svg"),
  caption: [Porównanie czasu obliczeń w zależności od rozmiaru macierzy dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU]
) <PorównanieCzasuObliczeńWZależnościOdRozmiaruMacierzyDlaMetodJacobiegoGaussaSeidelaIFaktoryzacjiLU>

Jak widać na #link(<PorównanieCzasuObliczeńWZależnościOdRozmiaruMacierzyDlaMetodJacobiegoGaussaSeidelaIFaktoryzacjiLU>)[wykresie czasu obliczeń w zależności od rozmiaru macierzy dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU], metoda faktoryzacji LU jest zdecydowanie wolniejsza od metod iteracyjnych co jest mocno odczuwalne dla dużych macierzy. Metoda Gaussa-Seidela jest szybsza od metody Jacobiego dla wszystkich rozmiarów macierzy.

= 5. Podsumowanie

W ramach projektu zaimplementowane zostały metody Jacobiego i Gaussa-Seidela oraz metoda faktoryzacji LU. Przeprowadzone testy wydajnościowe pozwoliły na porównanie czasu wyznaczenia rozwiązań układów równań liniowych w zależności od zastosowanej metody oraz rozmiaru macierzy. Podczas testów wydajnościowych zauważono, że metoda faktoryzacji LU jest zdecydowanie wolniejsza od metod iteracyjnych (nawet 9 razy wolniejszy w przypadku macierzy $3000 #sym.times 3000$), co jest mocno odczuwalne dla dużych macierzy. Metoda Gaussa-Seidela jest szybsza od metody Jacobiego dla wszystkich rozmiarów macierzy. Mimo tego metoda faktoryzacji LU jest najdokładniejsza, co widać na przykładzie alternatywnego układu równań liniowych, który nie był zbieżny dla metod iteracyjnych.

W ogólności zdaje się, że przy rozwiązywaniu dowolnej klasy układów równań liniowych należałoby na początek skorzystać z metody Gaussa-Seidela, a w przypadku braku zbieżności (co można wykryć poprzez zauważenie, że bład zamiast maleć przy kolejnych iteracjach wzrasta) zastosować metodę faktoryzacji LU. Powinno to pozwolić na uzyskanie dokładnych wyników w krótkim czasie tak długo jak układ równań jest zbieżny, oraz dać możliwość uzyskania wyników dla układów równań, które nie są zbieżne dla metod iteracyjnych.

Ponadto warto zauważyć, że zastosowanie zewnętrznych bibliotek do obliczeń macierzowych (np. NumPy) lub zastosowanie szybszego języka do implementacji powinno pozwolić na znaczne przyspieszenie obliczeń, co jest szczególnie ważne dla dużych macierzy. Testowana implementacja była napisana w czystym języku Python, który nie jest językiem szybkim, co *znacząco* wpłynęło na czas obliczeń (zwłaszcza metody faktoryzacji LU, która zajęła nawet 20 min dla macierzy $3000 #sym.times 3000$).