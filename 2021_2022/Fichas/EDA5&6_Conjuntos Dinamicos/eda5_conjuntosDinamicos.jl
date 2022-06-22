#Criado para poder mudar os valores da struct, porque
 #It looks like the module name is available as a global variable within the module, 
 #so when you define your ProjectedNormal struct, 
 #it’s trying to redefine the constant module reference. 
module MyModule #!Perguntar prof porque sem nomear module dá erro

#Importações


#*-------
#*Definição da estrutura, deve ser mutable porque queremos alterar os valores internos


#*------------STACK AND FUNCTIONS---------------------
#*....Stack "Class"
mutable struct MyStack
    #Nome da variável::tipo
    top::Int64
    content::Vector{Int64}
end
#Construtor
function MyStack(n::Int64)
    content = zeros(Int64, n) #Tipo inteiro com 'n' de espaco
    MyStack(0, content) #Top sempre inicializa a zero
end
#Push
function my_push!(S::MyStack, x::Int64)
    if(S.top == length(S.content))
        println("Overflow!")
    else
        S.top = S.top + 1 #Esta ordem de adic index e depois colocar , faz com que pos comece sempre no 1 e deve ser assim por causa do Julia
        S.content[S.top] = x
    end
    
end 

#*------
#Stack Empty
function my_stack_empty!(S)
    if(S.top == 0)
        return true
    else
        return false
    end
end

#Pop
function my_pop!(S)
    if my_stack_empty!(S)
        println("Underflow!")
    else
        S.top = S.top - 1 #Podemos não tirar já que no proximo push vamos sobrepor o numero
        return S[S.top + 1]
    end
end

#*------------QUEUE FUNCTIONS---------------------
#*....Queue "Class"
mutable struct MyQueue
    #Nome da variável::tipo
    head::Int64
    tail::Int64
    size::Int64 #Varivael adicionada para usar isEmpty e isFull
    content::Vector{Int64}
end
#Construtor
function MyQueue(n::Int64)
    content = zeros(Int64, n) #Tipo inteiro com 'n' de espaco
    MyQueue(1, 1, 0,content) #Head e tal sempre inicializa a 1
end

#*----
#isFull
function my_isFull_Queue!(Q::MyQueue) 
    return Q.size == n #N é o tamanho da queuue
end

#isEmpty
function my_isEmpty_Queue!(Q::MyQueue) 
    return Q.size == 0 
end
#Enqueue
function my_enqueue!(Q::MyQueue, x::Int64)
    #Se não tiver cheia, pode adicionar elementos
    if my_isFull_Queue!(Q) == false
        Q.content[Q.tail] = x #Colocar o valor na cauda
        Q.size = Q.size + 1 #Já que sempre vamos add um valor, independentemente da pos da atil, adicionamos mais 1 a size

        #Se já estiver a apontar a ultima pos, reapontar a 1ª
        if Q.tail == length(Q.content)
            Q.tail = 1
        else
            Q.tail = Q.tail + 1
        end
    else
        println("Queue is Full, dequeue some element!")
    end
end

#Dequeue
function my_dequeue!(Q::MyQueue)
    #Se não tiver vazia, pode retirar elementos
    if my_isEmpty_Queue!(Q) == false
        x = Q.content[Q.head] #Valor que está na pos head
        Q.size = Q.size - 1 #Já que sempre vamos tirar um valor, independentemente da pos da head, diminuimos menos 1 a size

        #Se já estiver a apontar a ultima pos, reapontar a 1ª
        if Q.head == length(Q.content)
            Q.head = 1
        else
            Q.head = Q.head + 1
            return x
        end
    else
        println("ERROR! Queue is empty!")
    end
end

#*------------LINKEDLIST AND FUNCTIONS---------------------
#*....LinkedList
mutable struct MyNode
    #Next e Prev são do tipo "Any" pois temos casos de nodes sem prev e sem next
     #Logo, pode ser ou node ou nil

    #Key NESTE CASO é um valor inteiro, mas pode não ser
    key::Int64
    prev::Any
    next::Any
end
#Construtor
function MyNode(key::Int64)
    #MyNode Construtor Call
    MyNode(key,"nil","nil") #Prev e Next sempre inicializa a nil
end
#*--
mutable struct MyLinkedList
    #Tipo any porque pode ser Node ou Nil
    head::Any
    tail::Any 

end
#Construtor
function MyLinkedList()
    #list_size = 9
    #content = zeros(Int64, list_size) #Tipo inteiro com 'list_size' de espaco
    #content = Array{MyNode}(undef,list_size) #Deve ser Any e não Int, pois pode ser necessário ver quais posições estã undef
    MyLinkedList("nil", "nil")#Head e Tail são inicializados nil
end

#*---
function my_list_insert!(L::MyLinkedList, x::MyNode)
    #O novo elemento tem como next o que está no head, que vai ser o último elemento inserido
    x.next = L.head 
    #Se houver head, este terá como prev SEMPRE o novo nó
    if  L.head != "nil"
        L.head.prev = x #O antigo head vai apontar para o novo head que é o elemento inserido
    
    #!PERGUNTAR PROF SE FAZ SENTIDO, COD ADD
    else 
        L.tail = x #Tail é definido só uma vez
    end
    #Aqui basicamente é, todo novo elemento, passa a ser apontado pelo L.head, é um pouco confuso porque é feita uma troca de "apontação"
    L.head = x
    x.prev = "nil"
end

function my_list_delete!(L::MyLinkedList, x::MyNode)
    #Se o anterior de X não for nil
    if x.prev != "nil"
        x.prev.next = x.next #anterior de x passa a ter o próximo de x
    else
        L.head = x.next #Se for nill, next passa a ser novo head
    end

    #Se próximo de x não for nill
    if x.next != "nil"
        x.next.prev = x.prev #próximo de x passa a ter prev do x
    end
end

function my_list_search!(L::MyLinkedList, k::Int64)
    #Apontamos para a cabeça da lista
    x = L.head
    
    #Percorremos a lista enquanto o x não for nil e enquanto não encontramos o valor procurado
    while  x != "nil" && x.key != k
        x = x.next #Pegar o next
    end
    return x 
end

#Functions call
function stack()
    #Stack
    len = 2 #stack length
    S = MyStack(len)
    println(S.content[1])
end

function queue()
    #Queue
    len = 2 #queue length
    Q = MyQueue(len)
    my_dequeue!(Q)
    my_enqueue!(Q, 4)
    my_enqueue!(Q, 34)
end

function linked_list()
    #LinkedList
    L = MyLinkedList()

    #Insert
    my_list_insert!(L, MyNode(7))
    my_list_insert!(L, MyNode(10))
    my_list_insert!(L, MyNode(4))
    my_list_insert!(L, MyNode(2))
    my_list_insert!(L, MyNode(5))

    #Delete
    my_list_delete!(L, MyNode(5))

    #Search
    println(my_list_search!(L, 5))
end

function gestao_memoria()
#Gestao de memoria
     #Criar a Pilha e Lista Ligada
     n = 2
     A = MyStack(n)
     my_push!(A, 2)
     my_push!(A, 2)
    
end


#MAIN 
function main()

    #Stack
    #stack()
    
    #Queue
    #queue()

    #LinkedList
    #linked_list()

    #Gestao de memoria
    gestao_memoria()
    
end

#Main Call
main()

end
