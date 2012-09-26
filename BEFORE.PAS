UNIT BEFORE;
INTERFACE
USES M13H;
 type gox = 4..48;
      goy = 4..28;

 const dlugosc = 1056; {maksymalna dlugosc weza}
       MaxX = 319 ; {maksymalna szerokosc ekranu}
       MaxY = 199 ; {maksymalna dlugosc ekranu}
       obj = 6; {liczba objektow}
       game_name = 'Wezyk';
       game_ver = '1.30';

 var waz : array[1..dlugosc] of record
           jest  : boolean;
             x   : gox; {polozenie x weza}
             y   : goy; {polozenie y weza}
           lastx : gox;
           lasty : goy;
         end;

     randx : gox;
     randy : goy; {zmienne zawierajace polozenie obiektu}
     randobj : byte; {zmienna zaierajaca aktualny obiekt}
     eat : boolean; {zmienna pomocnicza}
     speed : byte; {zmienna zawierajaca szybkosc gry}

 const objects : array[1..obj, 0..35] of byte = {menu zarcia weza :)}
       ((0,0,96,96,0,0,
         0,128,128,128,0,0,   {jablko}
         128,255,255,128,128,0,
         128,255,128,128,128,0,
         0,128,0,128,0,0,
         0,0,0,0,0,0),

        (0,0,88,0,0,0,
         0,0,88,0,0,0,      {gruszka :)}
         0,88,95,88,0,0,
         88,95,95,88,88,0,
         0,88,95,88,0,0,
         0,0,0,0,0,0),

        (0,0,0,0,0,0,
         0,0,161,161,0,0,    {moneta}
         0,161,156,156,161,0,
         0,0,161,161,0,0,
         0,0,0,0,0,0,
         0,0,0,0,0,0),

        (0,0,0,0,0,0,
         0,0,0,0,0,0,     {sliwka :)}
         0,0,0,0,0,0,
         0,240,240,0,0,0,
         240,240,240,0,0,0,
         240,240,0,0,0,0),

        (0,0,0,0,194,0,
         0,0,0,194,0,0,
         0,124,0,0,0,0,     {wisnia}
         124,124,124,0,0,0,
         0,124,0,0,0,0,
         0,0,0,0,0,0),

        (16,0,0,19,19,0,
         16,16,0,0,19,0,   {skracarka :)}
         16,0,0,16,19,0,
         16,16,0,0,19,0,
         16,0,0,16,19,0,
         0,0,0,0,0,0));

       bodysnake : array[1..14, 0..35] of byte = {cialo weza}
       ((0,0,0,0,0,0,
         0,0,88,88,0,0,
         0,160,88,88,160,0,     {glowa do gory :)}
         88,88,88,88,88,88,
         88,88,160,88,88,88,
         0,160,88,88,88,0),

        (0,160,88,88,88,0,
         88,88,160,88,88,88,
         88,88,88,88,88,88,    {glowa do dolu}
         0,160,88,88,160,0,
         0,0,88,88,0,0,
         0,0,0,0,0,0),

        (0,0,0,88,88,0,
         0,0,160,88,88,88,
         0,88,88,88,88,88,     {glowa w lewo}
         0,88,88,88,160,88,
         0,0,160,88,88,160,
         0,0,0,88,88,0),

        (0,88,88,0,0,0,
         88,88,88,160,0,0,
         88,88,88,88,88,0,     {glowa w prawo}
         88,160,88,88,88,0,
         160,88,88,160,0,0,
         0,88,88,0,0,0),

        (0,0,0,0,0,0,
         88,88,88,160,88,88,
         88,88,160,88,160,88,     {tulow poziomo}
         88,160,88,88,88,160,
         160,88,88,88,88,88,
         0,0,0,0,0,0),

        (0,88,160,88,88,0,
         0,88,88,160,88,0,
         0,88,88,88,160,0,   {tulow pionowo}
         0,88,88,160,88,0,
         0,88,160,88,88,0,
         0,160,88,88,88,0),

        (0,160,88,88,88,0,
         0,88,160,88,88,88,
         0,88,88,160,88,88,     {ukos lewo-do-gory}
         0,0,88,88,160,88,
         0,0,0,88,88,160,
         0,0,0,0,0,0),

        (0,88,160,88,88,0,
         88,88,160,88,88,0,
         88,88,160,88,88,0,     {ukos prawo-do-gory}
         88,160,88,88,0,0,
         160,88,88,0,0,0,
         0,0,0,0,0,0),

        (0,0,0,0,0,0,
         0,0,0,88,88,88,
         0,0,88,88,88,88,   {ukos lewo-do-dolu}
         0,88,88,160,160,160,
         0,88,160,88,88,88,
         0,160,88,88,88,0),

        (0,0,0,0,0,0,
         88,88,88,0,0,0,
         88,88,88,88,0,0,     {ukos prawo-do-dolu}
         88,88,88,88,88,0,
         160,160,88,88,88,0,
         0,88,160,88,88,0),

        (0,0,0,0,0,0,
         0,0,88,88,0,0,
         0,88,88,88,160,0,       {ogon w dol}
         0,88,88,160,88,0,
         0,88,160,88,88,0,
         0,160,88,88,88,0),

        (0,88,160,88,88,0,
         0,88,88,160,88,0,
         0,88,88,88,160,0,       {ogon w gore}
         0,88,88,160,88,0,
         0,0,160,88,0,0,
         0,0,0,0,0,0),

        (0,0,0,0,0,0,
         0,0,88,160,88,88,
         0,88,160,88,160,88,       {ogon w lewo}
         0,160,88,88,88,160,
         0,0,88,88,88,88,
         0,0,0,0,0,0),

        (0,0,0,0,0,0,
         88,88,88,160,0,0,
         88,88,160,88,160,0,       {ogon w prawo}
         88,160,88,88,88,0,
         160,88,88,88,0,0,
         0,0,0,0,0,0));

 procedure losuj; {losuje polozenie obiektow i wyswietla je}
 procedure wydluz(x : byte); {wydluza weza o x pol}
 procedure skroc(x : byte); {skraca weza o x pol}
 procedure rysuj_weza; {rysuje weza na ekranie}
 procedure rysuj_objekt(nr : byte; x : gox; y : goy);

IMPLEMENTATION

 procedure losuj;
   var x : integer; {zmienna pomocnicza}
 begin
   x := 1;
   randx := (random(44) + 5);
   randy := (random(24) + 5);
   randobj := random(obj) + 1;
   repeat
     if (waz[x].x = randx) and (waz[x].y = randy) then
     begin
       randx := (random(44) + 5);
       randy := (random(24) + 5);
       x := 0;
     end;
     x := x + 1;
   until waz[x].jest = false;
   if (waz[120].jest = false) and (randobj = 6) then randobj := random(5) + 1;
   {he, he, ograniczenie blokujace wylosowanie
   skracacza, gdy waz jest zbyt krotki :P}

   rysuj_objekt(randobj, randx, randy);
 end;

 procedure wydluz(x : byte);
   var licznik : integer; {zmienna liczaca aktualna dlugosc weza}
 begin
   licznik := 1; {"wyzeruj" zmienna}
   while waz[ licznik ].jest do
   begin
     licznik := licznik + 1;
   end;

   for licznik := licznik to licznik + x - 1 do {wydluz w odpowiednia strone}
   begin
     waz[ licznik ].jest := true;
     if (waz[ licznik - 2 ].x < waz[ licznik - 1 ].x) and (waz[ licznik - 2 ].y = waz[ licznik - 1 ].y) then
     begin
        waz[ licznik ].x := waz[ licznik - 1 ].x + 1;
        waz[ licznik ].y := waz[ licznik - 1 ].y;
     end else
     if (waz[ licznik - 2 ].x > waz[ licznik - 1 ].x) and (waz[ licznik - 2].y = waz[ licznik - 1 ].y) then
     begin
        waz[ licznik ].x := waz[ licznik - 1 ].x - 1;
        waz[ licznik ].y := waz[ licznik - 1 ].y;
     end else
     if (waz[ licznik - 2 ].y < waz[ licznik - 1 ].y) and (waz[ licznik - 2 ].x = waz[ licznik - 1 ].x) then
     begin
        waz[ licznik ].y := waz[ licznik - 1 ].y + 1;
        waz[ licznik ].x := waz[ licznik - 1 ].x;
     end else
     if (waz[ licznik - 2 ].y > waz[ licznik - 1 ].y) and (waz[ licznik - 2 ].x = waz[ licznik - 1 ].x) then
     begin
        waz[ licznik ].y := waz[ licznik - 1 ].y - 1;
        waz[ licznik ].x := waz[ licznik - 1 ].x;
     end else
   end;
 end;

 procedure skroc(x : byte);
    var licznik : integer; {zmienna liczaca aktualna dlugosc weza}
 begin
   licznik := 1; {"wyzeruj" zmienna}
   while waz[ licznik ].jest do
   begin
     licznik := licznik + 1;
   end;

   for licznik := licznik downto licznik - x + 1 do
   begin
     waz[ licznik ].jest := false;
     Fill( waz[ licznik ].x * 6, waz[ licznik ].y * 6, (waz[ licznik].x * 6) + 5, (waz[ licznik ].y * 6) + 5,  0);
     waz[ licznik ].x := 4;
     waz[ licznik ].y := 4;
   end;
 end;

  procedure rysuj_cialo(nr : byte; x : gox; y : goy); {procedura wewnetrzna rysujaca kawalek weza :)}
   var z : byte;
 begin
  for z := 0 to 35 do
  PutPixel( x * 6 + z mod 6, y * 6 + z div 6, bodysnake[nr, z]);
 end;

 procedure rysuj_weza; {a tu juz calosc}
   var z : integer; {zmienna liczaca komorki weza}
 begin

{   rysuj_objekt(randobj, randx, randy);}

   z := 2;

   repeat
     z := z + 1;
   until waz[z + 1].jest = false;

  {czyszczenie ostatniego punktu}

   Fill(waz[z].lastx * 6, waz[z].lasty * 6, waz[z].lastx * 6 + 5, waz[z].lasty * 6 + 5, 0);

   z := 2;

  { rysowanie glowy }
   if waz[1].x > waz[2].x  then rysuj_cialo(4, waz[1].x, waz[1].y) else
   if waz[1].x < waz[2].x  then rysuj_cialo(3, waz[1].x, waz[1].y) else
   if waz[1].y > waz[2].y  then rysuj_cialo(2, waz[1].x, waz[1].y) else
   if waz[1].y < waz[2].y  then rysuj_cialo(1, waz[1].x, waz[1].y);

  {rysowanie tulowia}

   repeat
     if z > 1 then
     begin
       if (waz[z - 1].x <> waz[z + 1].x)  and (waz[z - 1].y = waz[z + 1].y) then
           rysuj_cialo(5, waz[z].x, waz[z].y) else
       if (waz[z - 1].y <> waz[z + 1].y)  and (waz[z - 1].x = waz[z + 1].x) then
           rysuj_cialo(6, waz[z].x, waz[z].y) else
       if ((waz[z - 1].lastx < waz[z - 1].x) and
           (waz[z + 1].y > waz[z].y)) or
          ((waz[z - 1].lasty < waz[z - 1].y) and
           (waz[z + 1].x > waz[z].x)) then
               rysuj_cialo(9, waz[z].x, waz[z].y) else
       if ((waz[z - 1].lastx > waz[z - 1].x) and
           (waz[z + 1].y > waz[z].y)) or
          ((waz[z - 1].lasty < waz[z - 1].y) and
           (waz[z + 1].x < waz[z].x)) then
               rysuj_cialo(10, waz[z].x, waz[z].y) else
       if ((waz[z - 1].lastx < waz[z - 1].x) and
           (waz[z + 1].y < waz[z].y)) or
          ((waz[z - 1].lasty > waz[z - 1].y) and
           (waz[z + 1].x > waz[z].x)) then
               rysuj_cialo(7, waz[z].x, waz[z].y) else
       if ((waz[z - 1].lastx > waz[z - 1].x) and
           (waz[z + 1].y < waz[z].y)) or
          ((waz[z - 1].lasty > waz[z - 1].y) and
           (waz[z + 1].x < waz[z].x)) then
               rysuj_cialo(8, waz[z].x, waz[z].y);
       z := z + 1;
     end;
   until waz[z + 1].jest = false;

  {rysowanie ogona }
   if waz[z - 1].x < waz[z].x then rysuj_cialo(14,waz[z].x, waz[z].y) else
   if waz[z - 1].x > waz[z].x then rysuj_cialo(13,waz[z].x, waz[z].y) else
   if waz[z - 1].y < waz[z].y then rysuj_cialo(12,waz[z].x, waz[z].y) else
   if waz[z - 1].y > waz[z].y then rysuj_cialo(11,waz[z].x, waz[z].y) else

 end;

 procedure rysuj_objekt(nr : byte; x : gox; y : goy);
   var z : byte;
 begin
  for z := 0 to 35 do
  if objects[nr, z] <> 0 then PutPixel( x * 6 + z mod 6, y * 6 + z div 6, objects[nr, z]);
 end;

END.