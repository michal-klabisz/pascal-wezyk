Unit Sound;

INTERFACE
Uses Crt;
type naglowek_WAV = record
                    tab_RIFF : array[0..3] of char;
                    rozmiar_pliku_bez_8 : longint;
                    tab_WAVE : array[0..3] of char;
                    tab_fmt : array[0..3] of char;
                    liczba_bajtow_do_data : longint;
                    format_danych : word;
                    liczba_kanalow : word;
                    czestotliwosc : longint;
                    liczba_bajtow_na_sekunde : longint;
                    liczba_bajtow_na_cykl : word;
                    liczba_bitow_na_probke : word;
                    tab_data : array[0..3] of char;
                    rozmiar_danych_dzwiekowych : longint;
                    end;

type fala_dzwiekowa = record
                       naglowek : naglowek_WAV;
                       wsk_bufora : pointer;
                      end;

var
   port_2x6 : word;
   port_2xA : word;
   port_2xC : word;
   port_2xE : word;
   czestotliwosc : word; {cz©stotliwo˜† d«wi©ku}
   bufor_a  : fala_dzwiekowa;
   bufor_b  : fala_dzwiekowa;
   bufor_c  : fala_dzwiekowa;
   bufor_d  : fala_dzwiekowa;
   bufor_e  : fala_dzwiekowa;
   bufor_f  : fala_dzwiekowa;

 FUNCTION zresetuj_SB( baza : byte):boolean;
 PROCEDURE laduj_WAV (var data : fala_dzwiekowa; szciezka : string);
 PROCEDURE odegraj_WAV( fala : fala_dzwiekowa; czestotliwosc: word);
 PROCEDURE zwolnij_pam_w( data : fala_dzwiekowa);

IMPLEMENTATION

 PROCEDURE zapisz_do_SB(data : byte); {procedura wewnetrzna}
 begin

 while (port[port_2xC] and 128 = 128) do ;

 port[port_2xC] := data;

 end;

 FUNCTION zresetuj_SB( baza : byte):boolean;
 begin

   baza := baza shl 4;

   port_2x6 := $206 + baza;
   port_2xA := $20A + baza;
   port_2xC := $20C + baza;
   port_2xE := $20E + baza;

   port[port_2x6] := 1;
   delay(5);
   port[port_2x6] := 0;
   delay(5);

   if ((port[port_2xE] and 128 = 128) and (port[port_2xA] = $AA)) then
       zresetuj_SB := TRUE else
       zresetuj_SB := FALSE;

 end;

 PROCEDURE laduj_WAV (var data : fala_dzwiekowa; szciezka : string);
 var
 plik : file;
 licznik, wynik : word;
 licznik2 : word;
 begin

 assign(plik, szciezka);
 reset(plik, 1);
 licznik := sizeof(naglowek_WAV);


 blockread(plik, data.naglowek, licznik, wynik);


 if(maxavail < data.naglowek.rozmiar_danych_dzwiekowych) then
   begin
   close(plik);
   exit;
   end;


 getmem(data.wsk_bufora, data.naglowek.rozmiar_danych_dzwiekowych);


 licznik := data.naglowek.rozmiar_danych_dzwiekowych;
 blockread(plik, data.wsk_bufora^, licznik, wynik);


 close(plik);

 end;

 PROCEDURE odegraj_WAV( fala : fala_dzwiekowa; czestotliwosc: word);
 var
 stala_czasowa: byte;
 adres, strona: Word;
 rozmiar : word;
 begin


   adres  := seg(fala.wsk_bufora^) shl 4 + ofs(fala.wsk_bufora^);
   strona := (seg(fala.wsk_bufora^) + ofs(fala.wsk_bufora^) shr 4) shr 12;


   rozmiar := fala.naglowek.rozmiar_danych_dzwiekowych;


   port[$00A] := $05;


   port[$00B] := $49;


   port[$083] := strona;


   port[$00C] := 00;


   port[$002] := lo(adres);
   port[$002] := hi(adres);


   port[$00C] := 00;


   port[$003] := lo(rozmiar);
   port[$003] := hi(rozmiar);


   port[$00A] := $01;


   stala_czasowa := 256 - (1000000 div czestotliwosc);
   zapisz_do_SB($40);
   zapisz_do_SB(stala_czasowa);


   zapisz_do_SB($14);
   zapisz_do_SB(lo(rozmiar));
   zapisz_do_SB(hi(rozmiar));

 end;

 PROCEDURE zwolnij_pam_w( data : fala_dzwiekowa);
 begin

 freemem(data.wsk_bufora, data.naglowek.rozmiar_danych_dzwiekowych);

 end;


END.