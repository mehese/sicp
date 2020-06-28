#include <stdio.h>
#include <string.h>

#define MAX_INPUT_SIZE 10000

char *eval_input(char *input){
    switch(input[0]) {
        case '(' :
            printf("input is a list!\n");
            break;
        case '\'':
            printf("input is a quote!\n");
            break;
        default :
            printf("input is an atom\n");
            break;

    };
    return input;
}

int main() {

    char input[MAX_INPUT_SIZE];
    char output[MAX_INPUT_SIZE];

    for (;;){
        printf("Scheme > ");
        fgets(input, MAX_INPUT_SIZE, stdin);
        printf("\nOutput:\n");
        printf("%s\n", eval_input(input));
    }

    printf("All done!\n");
    
    return 0;
}

/*
 * Obviously could not have made this without peaking in different places like
 *
 * https://github.com/petermichaux/bootstrap-scheme
 *
 * https://github.com/skanev/playground/tree/master/scheme/sicp/05/support/51
 *
 * Not surprisingly, few who tried their hands at actually solving the problems in 
 * SICP got this far. Unfortunately for me, the text of the problem goes like
 *     
 *     Develop a rudimentary implementation of Scheme in C (or some other low-level 
 *     language of your choice)
 *
 * Had the text mercifully not used the term low-level I would have just went for
 * Python and used Norvig's own https://norvig.com/lispy.html
*/
 
