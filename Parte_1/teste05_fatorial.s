tipo:
   int = inteiro

fun��o:
   fatorial( valor int:n ) =
      local:
         fat: int := 1

      a��o:
         enquanto n > 1 fa�a
            fat := fat * n;
            n := n - 1
         fenquanto;
         imprime(fat)

a��o:
   fatorial(10)
