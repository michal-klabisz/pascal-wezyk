UNIT M13H; {Unit do obslugi trybu 13H (320*200)}
INTERFACE

 procedure Set13hMode;
 procedure Set3hMode;

 procedure PutPixel(x,y : Integer; color : Byte);
 function  GetPixel(x, y : Word) : Byte;
 procedure HLine(x1, x2, y : integer; color : Byte); {linia pozioma - horizontal}
 procedure VLine(y1, y2, x : integer; color : Byte); {linia pionowa - vertical}
 procedure Rectangle(x1, y1, x2, y2 : integer; color : byte); {rysuje prostokat}
 procedure Fill(x1, y1, x2, y2 : integer; color : byte); {wypelnia miejsce podane przez uzytkowanika na podany kolor :)}

 procedure Palette(NUMER, r, g, b :byte);
 procedure GetPalette(NUMER :byte; var r, g, b:byte);
 procedure LoadPalette(fileName : string);
 procedure SavePalette(fileName : string);

 procedure FadeOut;

 procedure PutChar( aChar : char; xPos, yPos : word; color : byte );
 procedure PutString( aString : string; xPos, yPos : word; color : byte );

 procedure Clrscr13; {czysci ekran}

IMPLEMENTATION
 uses crt, fnt;

 procedure Set13hMode; assembler;
 asm
    mov ax,13h  {rejestr AX ustawiamy na 13h}
    int 10h  {wywo³ujemy przerwanie 10h}
 end; {Set13hMode}

 procedure Set3hMode; assembler;
 asm
    mov ax,3h  {rejestr AX ustawiamy na 3h}
    int 10h  {wywo³ujemy przerwanie 10h}
 end; {Set3hMode}

 procedure PutPixel(x,y : Integer; color : Byte);
 begin
    Mem[$A000:x+y*320]:=color;
 end;

 Function GetPixel(x, y : Word) : Byte; Assembler;
    Asm
     push  ds
     mov   ax,0a000h
     mov   ds,ax
     mov   ax,y
     shl   ax,6
     mov   si,ax
     shl   ax,2
     add   si,ax
     add   si,x
     lodsb
     pop   ds
    End;

 procedure HLine(x1, x2, y : integer; color : Byte);
 begin
   for x1 := x1 to x2 do PutPixel(x1, y, color);
 end;

 procedure VLine(y1, y2, x : integer; color : Byte);
 begin
   for y1 := y1 to y2 do PutPixel(x, y1, color);
 end;

 procedure Rectangle(x1, y1, x2, y2 : integer; color : byte);
 begin
   HLine(x1, x2, y1, color);
   HLine(x1, x2, y2, color);
   VLine(y1, y2, x1, color);
   VLine(y1, y2, x2, color);
 end;

 procedure Fill(x1, y1, x2, y2 : integer; color : byte);
 begin
   for y1 := y1 to y2 do
       HLine(x1, x2, y1, color);
 end;

 procedure Palette(NUMER, r, g, b :byte);
 begin
    port[$3c8] := NUMER;
    port[$3c9] := r;
    port[$3c9] := g;
    port[$3c9] := b;
 end;

 procedure GetPalette(NUMER :byte; var r, g, b:byte);
 begin
    port[$3c7] := NUMER;
    r := port[$3c9];
    g := port[$3c9];
    b := port[$3c9];
 end;

 procedure LoadPalette(fileName : string);
 var f : file of byte;
    palIndex : word;
    red, green, blue : byte;
    code : integer;
 begin
    Assign(f, fileName);
    Reset(f);
    palIndex := 0;
    repeat
        Read(f, red);
        Read(f, green);
        Read(f, blue);
        Palette(palIndex, red, green, blue);
        palIndex := palIndex + 1;
    until (EOF(f));
    Close(f);
 end;

{ ******* }

 procedure SavePalette(fileName : string);
 var f : file of byte;
    i : byte;
    red, green, blue : byte;
 begin
    Assign(f, fileName);
    ReWrite(f);
    for i := 0 to 255 do
    begin
        GetPalette(i, red, green, blue);
        Write(f, red);
        Write(f, green);
        Write(f, blue);
    end;
    Close(f);
 end;

 procedure FadeOut;
   var i, j, r, g, b : byte;
 begin
    for i := 0 to 63 do
    begin
        for j := 0 to 255 do
        begin
            GetPalette( j, r, g, b );
            Dec(r); Dec(g); Dec(b);
            if r >= 63 then r := 0;
            if g >= 63 then g := 0;
            if b >= 63 then b := 0;
            Palette( j, r, g, b );
        end;
        Delay( 25 );
    end;
 end;

 procedure PutChar( aChar : char; xPos, yPos : word; color : byte );
 var i, j, chrNum : byte;
 begin
    chrNum := Ord(Upcase(aChar)) - 32;
    for i := 0 to 24 do
    begin
        if theFont[chrNum, i] = 1 then PutPixel( xPos + i mod 5, yPos + i div 5, color );
    end;
 end;

 procedure PutString( aString : string; xPos, yPos : word; color : byte );
 var i : byte;
 begin
   for i := 1 to Length(aString) do
   begin
      PutChar( aString[i], xPos, yPos, color );
      xPos := xPos + 5;
   end;
 end;

 procedure Clrscr13;
 begin
  FillChar(Mem[$A000:0000], 64000, 0);
 end;

END.