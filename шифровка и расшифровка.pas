

var mas:array[1..13, 1..7] of char;
    capsMas:array[1..13, 1..7] of char;
    k:integer;
    userInp:string;
    f:text;
    
const symbols:string = '0123456789абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz.,-;:"+*#@()!?[]{}/|\&';
    capsSymbols:string = '0123456789АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ.,-;:"+*#@()!?[]{}/|\&';
    x:string = '02468BD';
    y:string = '13579ACEGIKMO';

label chooseAgain;
label chooseStepSec1;
label chooseStepSec2;
    
function Cipher(str:string):string;
begin
  var itogy:string;
  
  for var i := 1 to length(str) do begin
    if str[i] = ' ' then itogy := itogy + ' '; 
    for var j := 1 to 13 do begin
      for var n := 1 to 7 do begin

        if ((j = 2) and (n >= 4)) or ((j > 2) and (j <= 9)) or ((j = 10) and (n <> 7)) then begin
          if str[i] = capsMas[j][n] then itogy := itogy + x[n] + y[j];
        end;
        
        if str[i] = mas[j][n] then itogy := itogy + y[j] + x[n];
      end;
    end;
  end;
  
  Cipher := itogy;
end;

function unCipher(str:string):string;
begin
  
  var itogy:string;
  var k:integer;
      
  for var i := 2 to length(str) do begin 
    
    if str[i] = ' ' then begin
      itogy := itogy + ' ';
      if k <> 1 then
        k := k + 1
      else k := 0
    end;
    
    for var j := 1 to 13 do begin
      for var n := 1 to 7 do begin
        if (i+k) mod 2 = 0 then begin
          
          if y[j] = str[i] then begin
            if x[n] = str[i-1] then itogy := itogy + capsMas[j][n];
          end else if x[n] = str[i] then
            if y[j] = str[i-1] then itogy := itogy + mas[j][n];
          
        end;
      end;
    end;
    
  end;
  
  unCipher := itogy;
end;
    
    
begin
  
  assign(f, 'output.log');
  if not fileexists('output.log') then assignfile(f, 'output.log');
  rewrite(f);
  
  
  //помещаем в порядок расшифрованных цифр и букв
  for var i := 1 to 13 do begin
    for var j := 1 to 7 do begin
      k := k + 1;
      mas[i][j] := symbols[k];
      capsMas[i][j] := capsSymbols[k];
    end;
  end;
  //---------------------------------------------

    println('Введите текст: ');
    readln(userInp);
    
    
  
    chooseAgain:
    println('зашифровать или расшифровать? напишите 1 или 2: ');
    var choose:byte;
    readln(choose);
   
    if choose = 1 then begin
      
      chooseStepSec1:
      println('выберите степень защиты (рекомендуется делать до 10. Минимум 1. Максимум 25): ');
      var stepSec:byte;
      read(stepSec);
      
      
      
      if (stepSec > 1) and (stepSec <= 25) then begin
        writeln(f, '---------------------------------------------------');
        writeln(f, 'Шифрую: "' + userInp + '". Степень защиты: ' + stepSec);
        for var i := 1 to stepSec do userInp := Cipher(userInp)
      end else if stepSec <> 1 then goto chooseStepSec1;  
            
      
      writeln(f, 'Итог: ' + Cipher(userInp));
      writeln(f, '---------------------------------------------------');
      print(Cipher(userInp));
       
    end
    else if choose = 2 then begin
      
      chooseStepSec2:
      println('введите предположительную степень защиты(от 1 до 25): ');
      var stepSec:byte;
      read(stepSec);
      
      
      if (stepSec > 1) and (stepSec <= 25) then begin
        writeln(f, '---------------------------------------------------');
        writeln(f, 'Попытка расшифровать "' + userInp + '"');
        for var i := 1 to stepSec do userInp := unCipher(userInp)   
      end else if stepSec <> 1 then goto chooseStepSec2;
      
      writeln(f, 'Результат: ' + unCipher(userInp));
      writeln(f, '---------------------------------------------------');
      print(unCipher(userInp))
      
    end else goto chooseAgain;
  
  close(f);
  println;
  println('Результат сохранение в файл output.log');
  
end.