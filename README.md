## Andrzej Swatowski - Beatle

Beatle jest językiem funkcyjnym, inspirowanym głównie składnią i działaniem OCamla, jak i częściowo Haskellem.

W porównaniu do deklaracji języka z kwietnia pozwoliłem sobie wprowadzić kilka zmian, związanych głównie z niezaimplementowanymi funkcjonalnościami. Nie udało mi się zaimplementować rekurencyjnych typów algebraicznych, z tego też powodu z gramatyki wypadły patterny związane z typami algebraicznymi, konstruktory ADT (postaci `TIdent "of" "(" [Expr] ")"` oraz definicja typu jako fraza (instrukcja). Prócz tego postanowiłem usunąć możliwość umieszczania patternów jako argumenty funkcji (konstrukcja `let f 3 = 4`), koncentrując się na pattern matchingu zbudowanym wokół konstrukcji `match x with { case _ -> _ }`. Zaimplementowałem za to inferencję typów Hindleya-Milnera, ale biorąc pod uwagę brak ADT postanowiłem wyrzucić z gramatyki też adnotacje typów (nie da się teraz zrobić `let f (x : Int) -> Int = x`).

### Projekt
#### Uruchomienie
Projekt jest projektem Stackowym, aby go uruchomić należy użyć komend `stack build` oraz `stack run`.

Uruchomienie projektu bez argumentów linii poleceń skutkuje pojawieniem się REPLa wykorzystującego Haskeline. W tym trybie nie da się pisać wielolinijkowych fraz, wszystkie muszą zmieścić się w jednej linii.
Argumenty linii poleceń traktowane są jako nazwy kolejnych plików do zinterpretowania - wywołanie `stack run plik.bt` wczyta zawartość pliku `plik.bt` i zinterpretuje ją, wypisując wyniki na standardowe wyjście (a błędy na stderr).

#### Struktura 
W folderze `app` znajduje się plik `Main.hs`, który jest właściwym entrypointem programu.

W folderze `src` znajduje się kod interpretera, podzielony na pliki:
 - `AbsBeatle.hs`, `ErrM.hs`, `LayoutBeatle.hs`, `LexBeatle.hs`, `ParBeatle.hs` oraz `PrintBeatle.hs` są plikami automatycznie wygenerowanymi przez BNFC, z którego korzystałem. Gramatyka wprowadzona do BNFC znajduje się w pliku `Beatle.cf`,
 - `Expr.hs` zawiera definicje typów algebraicznych oznaczających odpowiednio wyrażenia do interpretacji *Expr* oraz typy *Type*,
 - `Values.hs` zawiera definicje typu algebraicznego *Value*, który jest rzeczywistym wynikiem ewaluacji danego wyrażenia,
 - `Errors.hs` zawiera definicje różnorakich błędów,
 - `TypeInference.hs` zawiera kod inferencji typów,
 - `Lambda.hs` odpowiada za ewaluację drzewa AST złożonego z *Expr*,
 - `Interpreter.hs` odczytuje przetworzone przez parser drzewo AST i tworzy z niego mniejsze drzewo *Expr*, które następnie przekazuje do `TypeInference.hs` oraz `Lambda.hs`.

### Ewaluacja
Core algorytmu ewaluacji oparty jest o "mini-interpreter języka funkcyjnego", który pojawił się na wykładzie. Zmodyfikowana wersja rozpoznaje rozszerzony rachunek lambda (rozszerzony o let/letrec, listy oraz pattern matching). Cały algorytm umieszczony jest w `Lambda.hs`.

### Inferencja typów
Inferencja typów oparta jest o sławny algorytm W, a część implementacji o zalinkowaną na Moodle'u pracę.
Inferencja funkcji wzajemnie rekurencyjnych jest możliwa, ale tylko w przypadku, gdy funkcje te mają te same typy (czyli na przykład klasyczne funkcje wzajemnie rekurencyjne `even` oraz `odd`). Do wnioskowania o rekurencji zastosowałem sztuczkę z otypowaniem kombinatora Y (*forall x. (x -> x) -> x*), a później rozszerzyłem to do większego kombinatora (*forall x. ([x] -> x) -> x*).

### Wykorzystane monady
Interpreter korzysta z monad State, Except, Input oraz IO, razem tworzących stos monad transformerów postaci **ExceptT  InterpreterError (StateT  Env (InputT  IO))**. State oraz Except odpowiadają odpowiednio za trzymanie map nazw na odpowiednie wartości (w tym domknięcia) oraz obsługę błędów.
ExceptT jest najbardziej zewnętrznym, ponieważ chciałem utrzymywać ciągłość stanu w REPLu nawet mimo ewentualnych błędów wykonania/typowania.
InputT jest transformerem wykorzystywanym przez Haskeline.

Ewaluator (`Lambda.hs`) używa za to Excepta obudowanego w Readera - **ReaderT  Env (Except  InterpreterError) Value**.

Inferencja typów korzysta ponownie ze State i Except, tylko, że odwrotnie (tak jak ewaluator) - **StateT  TcState (Except  InterpreterError)**, gdzie TcState służy za kontener na aktywną zmienną typową.
