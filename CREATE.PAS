Program Create; { tworzy nowy plik z lista najlepszych graczy }
 Type wyniki = record {rekord zawierajacy dane o graczu i wynik}
                 score : word;
                 name : string[8];
               end;
 Var f : file of wyniki;
     player : wyniki;
     x : byte;
Begin
  Player.name := 'Michal';
  Player.score := 0;
  Assign(f, 'top5.dat');
    Rewrite(f);
    for x := 1 to 5 do write(f, player);
  Close(f);
End.