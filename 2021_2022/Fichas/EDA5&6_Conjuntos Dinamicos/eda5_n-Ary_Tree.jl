#BINARY TREE
module N_Ary_Tree_Module

#*Node struct
mutable struct Node
    #Nome da variável::tipo
    value::Int64
    left_child::Any
    right_sibling::Any

end

#Tree Construtor
function Node(value::Int64)
    Node(value, "null", "null") 
end
#!-------------------------------------------------
#*Tree struct
mutable struct My_Tree
    #Nome da variável::tipo
    root::Any
    #left_child::Any
    #right_sibling::Any
end

#Tree Construtor
function Tree(root::Int64)
    My_Tree(Node(root)) 
end

function tree_add!(current_node::Any, value::Int64)
    #Não há filhos
    if(current_node.left_child == "null")
        current_node.left_child = Node(value) #Novo Filho

    #Há filhos
    else
        #Adicionar o filho no ultimo
        child = current_node.left_child
        while(true)
            if(child.right_sibling != "null")
                child = child.right_sibling
            else
                child.right_sibling = Node(value)
                break
            end
        end
    end

end


#*-----------------------------------------MAIN------------------------------
function main()
    T = Tree(10)
    tree_add!(T.root, 20)
    tree_add!(T.root, 30)
    tree_add!(T.root.left_child.right_sibling, 40)
    println(T.root)
    
end 

main()

end