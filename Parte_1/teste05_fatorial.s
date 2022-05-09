tipo:
   int = inteiro

função:
   fatorial( valor int:n ) =
      local:
         fat: int := 1

      ação:
         enquanto n > 1 faça
            fat := fat * n;
            n := n - 1
         fenquanto;
         imprime(fat)

ação:
   fatorial(10)
