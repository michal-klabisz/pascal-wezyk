UNIT STEROW; {sterowanie wezem}
INTERFACE
 USES BEFORE, PLIK, SOUND;

   var k : char; {zmienna znakowa}
   const y : byte = 1; {zmienna pomocnicza}

 Procedure Ruch; {sterowanie wezem}

IMPLEMENTATION

 Procedure Ruch; {przesuwa weza w okreslone miejscie}
   var x : integer; {"licznik"}
 Begin

   if (waz[1].x = randx) and (waz[1].y = randy) then
   begin
     eat := true;
     if param <> '-NOSOUND' then
     begin
       if (randobj < 6) and (randobj <> 3) then odegraj_WAV(bufor_b, czestotliwosc) else
       if randobj = 3 then odegraj_WAV(bufor_f, czestotliwosc) else
                           odegraj_WAV(bufor_c, czestotliwosc);
     end;
   end;

   if eat = true then
   begin
     if randobj = 1 then {jablko}
     begin
       if y < 4 then wydluz(1);
       y := y + 1;
       if y > 3 then
       begin
         eat := false;
         score.score := score.score + 150;
         y := 1;
         losuj;
       end;
     end else
     if randobj = 2 then {gruszka}
     begin
       if y < 5 then wydluz(1);
       y := y + 1;
       if y > 4 then
       begin
         eat := false;
         score.score := score.score + 100;
         y := 1;
         losuj;
       end;
     end else
     if randobj = 3 then {moneta}
     begin
       score.score := score.score + 500;
       losuj;
       y := 1;
       eat := false;
     end else
     if randobj = 4 then {sliwka}
     begin
       if y < 5 then wydluz(1);
       y := y + 1;
       if y > 4 then
       begin
         eat := false;
         score.score := score.score + 200;
         y := 1;
         losuj;
       end;
     end else
     if randobj = 5 then {wisnia}
     begin
       if y < 5 then wydluz(1);
       y := y + 1;
       if y > 4 then
       begin
         score.score := score.score + 250;
         eat := false;
         y := 1;
         losuj;
       end;
     end else
     if randobj = 6 then {skracacz}
     begin
       skroc(9);
       score.score := score.score + 400;
       eat := false;
       y := 1;
       losuj;
     end;
   end;

   if (score.score > 5000) and (speed = 0) then speed := 10 else {zwiekszenie szybkosci przy odpowiedniej liczbie punktow}
   if (score.score > 10000) and (speed = 10) then speed := 30 else
   if (score.score > 15000) and (speed = 30) then speed := 50 else
   if (score.score > 20000) and (speed = 50) then speed := 70 else
   if (score.score > 30000) and (speed = 70) then speed := 80;


   if (k <> #72) and (k <> #80) and (k <> #75) and (k <> #77) and (k <> #27) then {jesli wcisnieto jakis klawisz...}
   begin
     if waz[1].x > waz[2].x then k := #77 else
     if waz[1].x < waz[2].x then k := #75 else
     if waz[1].y > waz[2].y then k := #80 else
     if waz[1].y < waz[2].y then k := #72 else
   end;

   with waz[1] do {przesuniecie "glowy" weza...}
   begin
     if (k = #72) {gora} then
       begin
         lastx := x;
         lasty := y;
         y := y - 1;
       end else
     if (k = #80) {dol} then
       begin
         lastx := x;
         lasty := y;
         y := y + 1;
       end else
     if (k = #75) {lewo} then
       begin
         lastx := x;
         lasty := y;
         x := x - 1;
       end else
     if (k = #77) {prawo} then
       begin
         lastx := x;
         lasty := y;
         x := x + 1;
       end;
   end;

   if (waz[1].x > 48) or (waz[1].x < 4) or (waz[1].y > 28) or (waz[1].y < 4) then k := #27; {jesli waz wyszedl za daleko...}

   x := 2;

   repeat
     if (waz[1].x = waz[x].x) and (waz[1].y = waz[x].y) then {petla sprawdzajaca czy waz nie wszedl na siebie}
     begin
       k := #27;
       break;
     end;
     x := x + 1;
   until waz[x].jest = false;

   if waz[3].jest = false then k := #27; {jesli waz jest zbyt krotki to skoncz gre}

   x := 2;

   repeat
     waz[x].lastx := waz[x].x;
     waz[x].lasty := waz[x].y;
     waz[x].x := waz[x - 1].lastx;
     waz[x].y := waz[x - 1].lasty;
     x := x + 1;
   until waz[x].jest = false;
 End;

END.