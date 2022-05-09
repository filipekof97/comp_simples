tipo:
   int = inteiro

função:
   fibonacci( valor int:n ) =
      local:
         a: int := 0
         b: int := 1
         auxiliar: int := 0

      ação:
         para i de 0 limite n faça
            auxiliar := a + b;
            a := b;
            b := auxiliar;
            imprime( auxiliar )
         fpara

ação:
   fibonacci(10)
