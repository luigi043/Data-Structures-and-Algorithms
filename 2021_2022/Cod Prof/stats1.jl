"""
stats1.jl

Jose Jasnau Caeiro
2022-05-24

algumas estatisticas

"""

using Statistics
using Plots

function bubble_sort(A)
    for i = 1:length(A)
        for j = length(A):-1:i+1
            if A[j] < A[j-1]
                A[j-1], A[j] = A[j], A[j-1]
            end
        end
    end
end

function medida_tempo(N, M, funcao_ordenacao)
    T = zeros(M)
    
    for k = 1:M
        A = rand(N)
        T[k] = @elapsed funcao_ordenacao(A)
    end

    #Retiramos o 1º elemento pois no Julia a precompilação faz com que a 1ª chamada seja mais lenta
    popfirst!(T)

    # cálculo da media
    μ = mean(T)

    # cálculo do desvio padrão
    σ = std(T)

    ϵ = σ / μ * 100        
    return μ, σ, ϵ
end

function main()
    N_START = 10000
    N_END   = 20000
    ΔN      = 2000
    
    GAMA_N = N_START:ΔN:N_END 
    M = 31

    #println(length(GAMA_N))
    μ_vector = zeros(length(GAMA_N))

    k = 1 
    for n = GAMA_N
        μ_vector[k], σ, ϵ = medida_tempo(n, M, bubble_sort)
        k = k + 1
        μ = μ_vector[k] 
        println("média = $μ, desvio padrão = $σ, erro relativo = $ϵ") 
    end

    gr()
    plt = plot(GAMA_N, μ_vector )
    savefig(plt, "treta.pdf")
    _
    print("μ_vector = $μ_vector")

end

main()
