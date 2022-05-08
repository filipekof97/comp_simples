tipo:
   a = inteiro
   b = cadeia
   c = real
   d = [3] de inteiro
   e = { numero1: inteiro , numero2: inteiro }

global:
   nomeCad: b := "filipe"
   numReal: c := 3.6
   reg: e := { numero1 = 10 , numero2 = 11 }
   numInt: a := 10
   vetorInt: d := [ 3 , 6 , 5 ]

função:
   soma( valor b:a ) =
      ação: funcao1(a)

   bb( valor c:a) =
      ação: funcao2(a)

   cc( valor c:a): resp =
      ação: retorne resp

ação:
   aa(15);
   bb(15);
   cc(15)