︠d6037e74-72d3-4fba-817e-1a2243c746cas︠
import sage
import random
from sympy import nextprime, ceiling

domain = 52    # (ord('Z') - ord('A') + 1) * 2    # domain = 52(value given to the last char)
choice = 1

def Reverse(lst):
    lst.reverse()
    return lst


def generate_degree(k, n):
    if choice == 0: #degree is sq(n)
        return [ceiling(math.sqrt(n)), ceiling(math.sqrt(n))]
    if choice == 1:
        return [ceiling(math.sqrt(n*k)), ceiling(math.sqrt(n/k))]


def get_field(n):
    if(n<52):
        return GF(nextprime(domain))
    else:
        return GF(nextprime(n))     # get the the smallest prime p which is >= n


def char_to_ascii(c):
    if ord('A') <= ord(c) <= ord('Z'):    #A is converted to 1, Z to 26
        return ord(c) - ord('A') + 1
    if ord('a') <= ord(c) <= ord('z'):    # a is converted to 27, z converted to 52
        return ord(c) - ord('a') + 27
    return -1   #error


def ascii_to_char(a):
    if 1 <= a <= 26:               #1 is converted to A, 26 to Z
        return chr(a + 64)
    if 27 <= a <= 52:              #27 is converted to a, 52 to Z
        return chr(a + 70)
    return -1   #error


def make_coeffiecents(k, message):
    cof = []
    for i in range(0, k):
        c = char_to_ascii(message[i])
        if c == -1:
            print("************Invalid Input Message***************")
        cof.append(c)
    return cof


def coeffiecents_to_message(cofs):
    message = ""
    for c in cofs:
        val = ascii_to_char(c)
        message += val
    return message


def make_codeword(n, poly):
    codeword = []
    for i in range(0, n):
        codeword.append(poly(i))
    return codeword


def create_matrix(codeword, xDeg, yDeg, field, n):
    matrix = Matrix(field, (xDeg+1)*(yDeg+1))
    for i in range(0, n):
        row_i = []
        for x in range(0, xDeg+1):
            for y in range(0, yDeg+1):
                item = (i^x) * (codeword[i]^y)
                row_i.append(item)
        matrix[i] = row_i
    return matrix


def create_Q(xDeg, yDeg, field, ker_vector):
    p_ring.<x,y> = PolynomialRing(field)
    Q = p_ring(0)
    for x_e in range(0, xDeg+1):
        for y_e in range(0, yDeg+1):
            i= y_e+x_e*(yDeg+1)   
            added_factor = ker_vector[i] * (x^x_e) * (y^y_e)
            Q = Q + added_factor
    return Q


def choose_factors(factored_Q, k, field):
    chosen_factors = []
    for factor in factored_Q:    #append to chosen_factors the p(x) factors that hold the 3 conditions
         p.<x,y> = PolynomialRing(field)
         if factor[0].degree(y) == 1 :
            if factor[0].coefficient({y:1}).degree(x) == 0 :
                if factor[0].degree(x) == k-1 :
                    chosen_factors.append(factor)
    final_polys = []
    for po in chosen_factors:      # turn chosen p(x) factors to the from of y-p(x)
        final_polys.append((-1)*(po[0].coefficient({y:0})))
    return final_polys


def polys_to_message(final_polys):
    decoded_list = []
    for p_factor in final_polys:
        cofs = Reverse(p_factor.coefficients())
        decoded_list.append(coeffiecents_to_message(cofs))
    return decoded_list


def encoder(k, n, m):
    p_ring.<x> = PolynomialRing(get_field(n))
    c = make_coeffiecents(k, m)
    poly = p_ring(c)              # poly = Polynomial of degree k-1 : c0*1 + c1*x +...+ cn-1*x^k-1
    return make_codeword(n, poly)


def make_erros(codeword, e):
    code_error = codeword
    for i in range(0, e):
        code_error[i] = randint(0, domain)
    return code_error

def decoder(k, n, codeword):
    degrees = generate_degree(k, n)  #if choose=0: degrees =sqrt(n)  || if choose=1: degree x = math.sqrt(n*k), degree y = (math.sqrt(n/k)
    xDeg = degrees[0]
    yDeg = degrees[1]
    field = get_field(n)
    matrix = create_matrix(codeword,xDeg,yDeg, field, n) #create a matrix consisted of all the (x^i)(y^j) 
    ker_matrix = matrix.right_kernel()
    i = 1
    ker_vector = ker_matrix[i]
    Q = create_Q(xDeg, yDeg, field, ker_vector)
    factored_Q = Q.factor()
    final_polys = choose_factors(factored_Q, k, field)
    decoded_list = polys_to_message(final_polys)
    return decoded_list

def test(k, n, errors, message):
    print("************************************Start Test************************************")
    codeword = encoder(k, n, message)
    corrupted_codeword = make_erros(codeword, errors)
    decoded_list = decoder(k, n, corrupted_codeword)
    #print("the decoded list is {}".format(decoded_list))
    if choice == 0:  #orignail sqrt(n degree)
        error_correction_rate = n-2*k*(math.sqrt(n))
    else:
        error_correction_rate = n-2*(math.sqrt(n*k))
    print("Given message=\"{}\" with k={}, n={}, errors={}".format(message, k, n, errors))
    print("Error Correction Rate = {} and the fraction of errors = {}".format(error_correction_rate, float(errors/n)))
    if message in decoded_list:
        print("Success! the message \"{}\", exists in the decoded list".format(message))
    else:
        print("The decoder didn't succeed in correcting the message with number of {} errors".format(errors))
    print("*************************************End Test*************************************")


def multipule_test(k, n, errors, message, times):
    print("**********************************Start Muiltipule Test**********************************")
    succ = 0
    error_correction_rate = n-2*(math.sqrt(n*k))
    for i in range(0,times):
        codeword = encoder(k, n, message)
        corrupted_codeword = make_erros(codeword, errors)
        decoded_list = decoder(k, n, corrupted_codeword)
        if message in decoded_list:
            succ += 1
    print("Error Correction Rate = {} and the fraction of errors = {}".format(error_correction_rate, float(errors/n)))
    print("Number of success = {} Number of failure = {}".format(succ, times-succ))
    print("*************************************End Test*************************************")

def main():
    #test 1: same message with different num of errors, choice = 0
    test(3, 140, 68, "abc")
    test(3, 140, 106, "abc")
    test(3, 500, 106, "abc") #when the the n is bigger(encoded message)
    test(3, 500, 400, "abc") #when the the n is bigger(encoded message) and also the errors

    #test 2 : change degree of x and y (change choice to 1) to show the improvment 
    #test(9, 729, 500, "CoronaVir") #should fail when choice = 0 , succeed when choice = 1

    #test3: check when k < sqrt(n)
    # test(13, 600, 0, "BguUniversity")
    # test(13, 100, 0, "BguUniversity")



    #test 2
#     multipule_test(13, 600, 423, "BguUniversity",5)             # success
#     multipule_test(13, 600, 428, "BguUniversity",5)  #some success some failure
#     multipule_test(13, 600, 429, "BguUniversity",5)  # all faulure

    #test3: Chan

main()
︡8f5e22cd-5ff7-4488-b028-733c2c3c9008︡{"stdout":"************************************Start Test************************************\nGiven message=\"abc\" with k=3, n=140, errors=68"}︡{"stdout":"\nError Correction Rate = 99.0121969362 and the fraction of errors = 0.485714285714\nSuccess! the message \"abc\", exists in the decoded list\n*************************************End Test*************************************\n************************************Start Test************************************\nGiven message=\"abc\" with k=3, n=140, errors=106"}︡{"stdout":"\nError Correction Rate = 99.0121969362 and the fraction of errors = 0.757142857143\nThe decoder didn't succeed in correcting the message with number of 106 errors\n*************************************End Test*************************************\n************************************Start Test************************************\nGiven message=\"abc\" with k=3, n=500, errors=106"}︡{"stdout":"\nError Correction Rate = 422.540333076 and the fraction of errors = 0.212\nSuccess! the message \"abc\", exists in the decoded list\n*************************************End Test*************************************\n************************************Start Test************************************\nGiven message=\"abc\" with k=3, n=500, errors=400"}︡{"stdout":"\nError Correction Rate = 422.540333076 and the fraction of errors = 0.8\nSuccess! the message \"abc\", exists in the decoded list\n*************************************End Test*************************************\n"}︡{"done":true}









