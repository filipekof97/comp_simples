tipo:
   int = inteiro
   intvet = [10] de inteiro

global:
   vetor: intvet := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
   numero: int := 3
   tamanho: int := 10

fun��o:
   buscaBinaria( valor intvet:vetor , valor int:numero , valor int:tamanho  ):int =
      local:
         begin: int := 0
         end: int := tamanho - 1
         i: int := 0

      a��o:
         enquanto begin <= end fa�a
            i := begin + end;

            se vetor[ i ] == numero verdadeiro
               retorne i
            fse;

            se vetor[ i ] < numero verdadeiro
               begin := i + 1
            falso
               end := i
            fse

         fenquanto;
         retorne 0

a��o:
   imprime( buscaBinaria( vetor , numero , tamanho ) )
