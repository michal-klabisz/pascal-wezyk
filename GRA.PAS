PROGRAM Wezyk ;
USES CRT, M13H, STEROW, BEFORE, PLIK, GVGA, SOUND;

  var x : integer;
      Obraz : TImage;
      Title : TImage;
      Menu : TImage;
      MSelect : TImage;
      done : boolean; {zmienna pomocnicza}

BEGIN
  linia_komend;
  czestotliwosc := 11025;
  if param <> '-NOSOUND' then
  begin
   zresetuj_SB(2);
   laduj_WAV(bufor_a, 'dzwiek.wav'); {dzwiek w menu}
   laduj_WAV(bufor_b, 'mniam.wav'); {zjadane owoce}
   laduj_WAV(bufor_c, 'brzdek.wav'); {spotkanie ze skracarka :)}
   laduj_WAV(bufor_d, 'begin.wav'); { wybranie pozycji z menu }
   laduj_WAV(bufor_e, 'end.wav'); { wyjscie z wybranej pozycji }
   laduj_WAV(bufor_f, 'gold.wav'); { sypiace sie zloto }
  end;
  Set13HMode; {inicjacja trybu 13H}
{---------------------------GLOWNE-MENU---------------------------------}
    Obraz.LoadBmp('title.bmp', true); {zaladowanie obrazka}
    Title.GetImg(0,0,320,60,Obraz);
    Menu.GetImg(0,70,51,45,Obraz);
    Ekran.PutImg(0,0,Title);
    Ekran.PutImg(140,100,Menu); {i wywalenie wszystkiego na ekran}
    laduj_liste; {wczytuje liste najlepszych graczy}

{GLOWNA PETLA}

    repeat

      if k = #72 then begin Dec(x); done := false; end else {gora}
      if k = #80 then begin Inc(x); done := false; end; {dol}

      if x < 0 then x := 3 else
      if x > 3 then x := 0;     {przesuwanie menu " w kolko "}
      {ZAZNACZANIE AKTUALNEGO WYBORU}
      if (x = 0) and (done = false) then
      begin
        MSelect.GetImg(51, 70, 52, 14, Obraz);
        Ekran.Putimg(140,100,Menu);
        Ekran.PutImg(140,100,MSelect);
        if param <> '-NOSOUND' then odegraj_WAV(bufor_a, czestotliwosc);
        done := true;
      end else
      if (x = 1) and (done = false) then
      begin
        MSelect.GetImg(51, 81, 51, 14, Obraz);
        Ekran.Putimg(140,100,Menu);
        Ekran.PutImg(140,111,MSelect);
        if param <> '-NOSOUND' then odegraj_WAV(bufor_a, czestotliwosc);
        done := true;
      end else
      if (x = 2) and (done = false) then
      begin
        MSelect.GetImg(53, 94, 51, 13, Obraz);
        Ekran.Putimg(140,100,Menu);
        Ekran.PutImg(140,124,MSelect);
        if param <> '-NOSOUND' then odegraj_WAV(bufor_a, czestotliwosc);
        done := true;
      end else
      if (x = 3) and (done = false) then
      begin
        MSelect.GetImg(54, 106, 51, 16, Obraz);
        Ekran.Putimg(140,100,Menu);
        Ekran.PutImg(140,136,MSelect);
        if param <> '-NOSOUND' then odegraj_WAV(bufor_a, czestotliwosc);
        done := true;
      end;
      {---------------------------}

      Delay(100);

      k := readkey;

      if k = #0 then k := readkey;

      {WYBRANA OPCJA}
      if (k = #13) or (k = #32) then
      begin
        if x = 1 then {TOP 5}
        begin
          if param <> '-NOSOUND' then odegraj_WAV(bufor_d, czestotliwosc);
          Fill(0, 61, 320, 200, 0);
          wyswietl_liste;
          readkey;
          if param <> '-NOSOUND' then odegraj_WAV(bufor_e, czestotliwosc);
          delay(300);
          Fill(0, 61, 320, 200, 0);
          done := false;
        end else
        if x = 2 then {CREDITS}
        begin
          if param <> '-NOSOUND' then odegraj_WAV(bufor_d, czestotliwosc);
          Fill(0,61,320,200,0);
          PutString(game_name + ' ver. ' + game_ver + ' by Michal Klabisz ', 3, 62,15);
          PutString('mk_cafe@poczta.onet.pl', 10, 80, 15);
          PutString('GG:5322792', 10, 88, 15);
          PutString('Ta gra jest freeware', 100, 115, 15);
          PutString('Nacisnij jakis klawisz...', 190,185,15);
          readkey;
          if param <> '-NOSOUND' then odegraj_WAV(bufor_e, czestotliwosc);
          delay(300);
          Fill(0,61,320,200,0);
          done := false;
        end else
        if x = 3 then begin if param <> '-NOSOUND' then odegraj_WAV(bufor_d, czestotliwosc); delay(200); break;  end {EXIT}
        else
        if x = 0 then {NOWA GRA}
        begin
          if param <> '-NOSOUND' then odegraj_WAV(bufor_d, czestotliwosc);
          ClrScr13;
          LoadPalette('palgame.dat');
          {zerowanie zmiennych}
          x := 1;
          repeat
            waz[x].jest := false;
            x := x + 1;
          until waz[x].jest = false;
          eat := false;
          speed := 0;
          score.score := 0;
          s := '';
          s2 := '';
          {--------------------}

          before.waz[1].jest := true;
          before.waz[1].x := 14; {ustal poczatkowe polozenie}
          before.waz[1].y := 14;
          before.waz[2].jest := true;
          before.waz[2].x := 13;
          before.waz[2].y := 14;
          wydluz(5); {wydluza weza}

          k := #77; {dzieki temu zaraz po uruchomieniu gry waz przesuwa sie w prawo}

          Rectangle(6 * 4 - 1, 6 * 4 - 1, 6 * 49, 6 * 29, 16); {rysuj obramowanie}
          randomize; {losowosc}
          losuj; {losuje polozenie obiektow}
          delay(100);
          repeat {powtarzaj...}
            if keypressed then k := readkey; {jesli cos wcisnieto to odczytaj wartosc}
            if k = #0 then k := readkey; {np. klawisze kierunkowe}
            s2 := s; {przypisz aktualna ( na razie ) wartosc wyniku}
            ruch; {uruchamia procedure kierujaca ruchami weza}
            if k <> #27 then rysuj_weza; {rysuje weza; dzieki k <> #27, gdy nacisnie sie esc, waz nie 'skraca sie'}
            Str(score.score, s);
            if s <> s2 then {jesli wynik sie zmienil to...}
            begin
              Fill(1, 9, 140, 15, 0);
              PutString('SCORE:' + s, 1, 10, 20); {...wyswietl wynik}
            end;
            Delay(100 - speed); {czekaj}
          until k = #27; {...dopoki nie wcisnieto escape}
          if param <> '-NOSOUND' then odegraj_WAV(bufor_e, czestotliwosc);
          delay(300);
          FadeOut;
          k := #77;
          ClrScr13;
          LoadPalette('palmenu.dat');

          if score.score > top[5].score then {jesli dostales sie na liste highscore...}
          begin
            score.name := '';
            x := 7;
            PutString('Dostales sie na liste najlepszych graczy', 70, 90, 15);
            PutString('Podaj Imie [max. 8 znakow]: ', 90 , 100, 30);
            repeat {...podaj imie...}
              k := readkey;
              if k = #8 {BackSpace} then
              begin
                Fill(100 + ((x - 1) * 5), 110,100 + ((x - 1) * 5 + 5), 115, 0);
                x := x - 2;
                if x < 6 then x := 6;
              end;
              PutChar(k, 100 + x * 5, 110, 30);
              if (k <> #8) and (k <> #13) then score.name := score.name + k;
              if (k = #8) then
              begin
                score.name := Copy(score.name, 1, length(score.name) - 1); {kopiuje zmienna bez ostatniego znaku}
              end;
              x := x + 1;
            until k = #13; {ENTER}
            ClrScr13;
            top[5] := score;
            sortuj; {...posortuj wszystko...}
            wyswietl_liste; {...i wyswietl}
            readkey;
            ClrScr13;
          end;
          x := 0;
          Ekran.PutImg(0,0,Title);
          Ekran.PutImg(140,100,Menu);
          Ekran.PutImg(140,100,MSelect);
        end;
      end;

    until k = #27;

    if x <> 3 then
    begin
      if param <> '-NOSOUND' then odegraj_WAV(bufor_e, czestotliwosc);
      delay(300);
    end;
{KONIEC GLOWNEJ PETLI}

    ClrScr13;
    PutString('THX FOR PLAYING!', 120, 90, 15);
    readkey;

  Set3HMode; {przywrocenie poprzedniego trybu}
  zapisz_liste;
  Title.FreeImg;
  Obraz.FreeImg;
  Menu.FreeImg;
  MSelect.FreeImg; {czysczenie pamieci z obrazkow...}
  if param <> '-NOSOUND' then
  begin
   zwolnij_pam_w(bufor_a);
   zwolnij_pam_w(bufor_b);
   zwolnij_pam_w(bufor_c);
   zwolnij_pam_w(bufor_d);
   zwolnij_pam_w(bufor_e);
   zwolnij_pam_w(bufor_f); {...i dzwiekow}
  end;
END.