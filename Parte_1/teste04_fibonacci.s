tipo:
   int = inteiro

fun��o:
   fibonacci( valor int:n ) =
      local:
         a: int := 0
         b: int := 1
         auxiliar: int := 0

      a��o:
         para i de 0 limite n fa�a
            auxiliar := a + b;
            a := b;
            b := auxiliar;
            imprime( auxiliar )
         fpara

a��o:
   fibonacci(10)
