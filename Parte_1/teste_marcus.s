tipo :
i= inteiro
x= inteiro
t= inteiro
y=cascata
z=real
v= [3] de inteiro
m= [2,2] de inteiro
r= { nome: cadeia , idade: inteiro}

global:
i: i := 0
vetor: v:= [1,2,3]
matriz: m:= [[1,2];[3,4]]
doc: r := { nome= "Marcus", idade = 37}


fun��o:

a( valor x:x)=
    local:
        x : x := 10
        y : z := 2.2
        z : y := "teste"

    a��o:
        enquanto x > 0fa�a
            continue;
            x := x-1
        fenquanto;


        enquanto x fa�a
            se x > 3 verdadeiro
                imprime(x)
            falso
                pare
            fse;
            x := x -1
        fenquanto

b( valor x:x): resp =
    local:
        c : x := 5
        x : v := [3,2,1]

    a��o:
        para i de 0 limite 5 fa�a
            imprime(i);
            resp := resp + i
        fpara;
        retorne resp



a��o :
    a(10);
    t := b(10)