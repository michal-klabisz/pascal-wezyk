Unit Plik;

INTERFACE
Uses M13H;
 type wyniki = record {rekord zawierajacy dane o graczu i wynik}
                 score : word;
                 name : string[8];
               end;
 var f : file of wyniki;
     s : string; { zmienna pomocnicza do wyswietlania wyniku }
     s2 : string; { zmienna pomocnicza zawierajaca poprzedni wynik}
     score : wyniki; {wynik i imie gracza}
     Top : array [1..5] of wyniki; {lista Top 5}
     param : string; {zmienna do pobrania komendy}

 procedure laduj_liste; {laduje liste z pliku}
 procedure zapisz_liste; {zapisuje liste do pliku}
 procedure sortuj;
 procedure wyswietl_liste; {wyswietla liste w danym kolorze}
 procedure linia_komend; {pobiera komendy z linii komend}
IMPLEMENTATION
 procedure laduj_liste;
   var x : byte;
 begin
   Assign(f, 'top5.dat');
     Reset(f);
     for x := 1 to 5 do read(f, top[x]);
   Close(f);
 end;
 procedure zapisz_liste;
   var x : byte;
 begin
   Assign(f, 'top5.dat');
     Rewrite(f);
     for x := 1 to 5 do write(f, top[x]);
   Close(f);
 end;
 procedure sortuj; {sortowanie babelkowe}
   var i, j : byte;
       temp : wyniki;
 begin
   for i := 5 downto 1 do
     for j := 5 downto 1 do
       if Top[i].score < Top[j].score then
       begin
         temp := Top[i];
         Top[i] := Top[j];
         Top[j] := temp;
       end;

 end;
 procedure wyswietl_liste;
   var x : byte;
       s : string;
 begin
   PutString('Top 5', 145, 85, 2);
   for x := 1 to 5 do
   begin
     Str(Top[x].score, s);
     PutString(Top[x].name, 130, 85 + x * 10, 2);
     PutString(s, 180, 85 + x * 10, 2);
   end;
 end;
 procedure linia_komend;
   var i : byte;
 begin
 param := ParamStr(1);
 for i := 1 to Length(param) do param[i] := UpCase(param[i]);
 end;
END.