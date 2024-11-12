#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <sys/ioctl.h>

char read_path[500];
char* datatype[4] = {"int","float","bool","char"};
char* cond_loop[4] = {"while","for","if","case"};
char* others[3] = {"#include","void","return"};

char search_terms[500] = "None";



int c_file_pointer = 0;//current file pointer
int ls_file_pointer = 0;//last save file pointer



//Undo and Redo
void SaveUndoRedo(char *text) {
    if (c_file_pointer < 20) { c_file_pointer++; }
    else { c_file_pointer = 0; }
    ls_file_pointer = c_file_pointer;

    char k[15] = "Cache/";
    char m[3];
    sprintf(m, "%d", c_file_pointer);
    strcat(k, m);
    strcat(k, ".txt");

    FILE* f = fopen(k, "w");
    if (!f) {
        perror("Error opening cache file for saving undo/redo");
        return;
    }
    fwrite(text, 1, strlen(text), f);
    fclose(f);
}








int get_terminal_width() {
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return w.ws_col; // Number of columns
}

void set_raw_mode() {
    struct termios term;
    // Get current terminal settings
    tcgetattr(STDIN_FILENO, &term);

    // Disable canonical mode and echo
    term.c_lflag &= ~(ICANON | ECHO);

    // Apply the new terminal settings
    tcsetattr(STDIN_FILENO, TCSANOW, &term);
}

void ClearScreen(){
    struct termios term;
    tcgetattr(STDIN_FILENO, &term); // Get current terminal attributes

    // Send the clear screen escape sequence
    write(STDOUT_FILENO, "\033[2J", 4); 
    write(STDOUT_FILENO, "\033[H", 3); // Move cursor to top-left corner

    tcsetattr(STDIN_FILENO, TCSANOW, &term); // Restore terminal attributes

}

void reset_terminal_mode() {
    struct termios term;

    // Get current terminal settings
    tcgetattr(STDIN_FILENO, &term);

    // Restore canonical mode and echo
    term.c_lflag |= (ICANON | ECHO);

    // Apply the restored settings
    tcsetattr(STDIN_FILENO, TCSANOW, &term);
}



int Count(char* text, char wrd) {
    int s = 0;
    for (int i = 0; i < strlen(text); i++) {
        if (text[i] == wrd) {
            s += 1;
        }
    }
    return s;
}

void SplitWrds(char* sentence) {
    //App Bar
    int tw = get_terminal_width();
    printf("\033[1;30;47mTEXT EDITOR   ");
    for(int i = 0; i< (tw-83)/2;i++){
        printf(" ");
    }
    printf("EXIT - CTRL+X     SEARCH - CTRL+H     UNDO - CTRL+K     REDO - CTRL+L");
    for(int i = 0; i< (tw-83)/2;i++){
        printf(" ");
    }
    printf("\033[0m\n");



    char st[8] = {' ', '<', '>', '[', ']', '\n', '(', ')'};
    int wrdsindex = 0;
    int delimindex = 0;
    int cwrdsindex = 0;
    int cdelimindex = 0;

    int len = strlen(sentence);
    char wrds[len][len]; 
    char delimiter[len][len];

    char currentwrd[len]; 
    char currentdelm[len];  
    currentwrd[0] = '\0';        
    currentdelm[0] = '\0';       

    for (int i = 0; i < len; i++)
    {
        bool notchar = false;
        for (int j = 0; j < 8; j++)
        {
            if (sentence[i] == st[j])
            {
                notchar = true;
                currentdelm[cdelimindex++] = sentence[i];
                currentdelm[cdelimindex] = '\0';

                if (strlen(currentwrd) > 0)
                {
                    currentwrd[cwrdsindex] = '\0';
                    strcpy(wrds[wrdsindex++], currentwrd);
                    cwrdsindex = 0;
                    currentwrd[0] = '\0';
                }
                break;
            }
        }

        if (!notchar)
        {
            currentwrd[cwrdsindex++] = sentence[i];
            currentwrd[cwrdsindex] = '\0';

            // Store the current delimiter if it exists
            if (strlen(currentdelm) > 0)
            {
                strcpy(delimiter[delimindex++], currentdelm);
                cdelimindex = 0;
                currentdelm[0] = '\0';
            }
        }
    }
    //Store any remaining words or delimiters
    if (strlen(currentwrd) > 0)
    {
        currentwrd[cwrdsindex] = '\0';
        strcpy(wrds[wrdsindex++], currentwrd);
    }
    if (strlen(currentdelm) > 0)
    {
        currentdelm[cdelimindex] = '\0';
        strcpy(delimiter[delimindex++], currentdelm);
    }

    // Highlight and print
    bool disp =true;
    int k = 0;

    while (disp)
    {
        disp = false;
        bool done = false;
        if(k<wrdsindex){
            // Data type
            for (int j = 0; j < 4; j++) {
                if (strcmp(wrds[k], datatype[j]) == 0 && strcmp(search_terms, datatype[j]) != 0) {
                    printf("\033[34m%s\033[0m", wrds[k]);
                    done = true;
                }
            }
            for (int j = 0; j < 4; j++) {
                if (strcmp(wrds[k], cond_loop[j]) == 0 && strcmp(search_terms, cond_loop[j]) != 0) {
                    printf("\033[31m%s\033[0m", wrds[k]);
                    done = true;
                }
            }
            for (int j = 0; j < 3; j++) {
                if (strcmp(wrds[k], others[j]) == 0 && strcmp(search_terms, others[j]) != 0) {
                    printf("\033[35m%s\033[0m", wrds[k]);
                    done = true;
                }
            }
            // Searched term
            if (strcmp(search_terms, wrds[k]) == 0) {
                printf("\033[42m%s\033[0m", wrds[k]);
                done = true;
            }
            if (!done) {
                printf("\033[0m%s", wrds[k]);
                done = false;
            }
            disp = true;
        }
        if (k < delimindex) {
            printf("%s",delimiter[k]);
            disp = true;
        }
        if(!disp){
            break;
        }
        k++;
    }
    
}


void ReadFile(){
    char *text= malloc(1);
    //reads te file and copy it to temp
    ClearScreen();
    printf("\033[1;30;47mENTER FILE PATH:\033[0m");
    char a[500];
    scanf("%s",a);
    FILE *f = fopen(a,"r");
    FILE *tmp_f = fopen("temp.txt","w");
    ClearScreen();
    while (true) {
        char c = fgetc(f);
        if (c == EOF) {
            break;
        } else {
            append(&text,c);
            fputc(c, tmp_f);
        }
    }
    strcpy(read_path,a);
    fclose(f);
    StartWriting(tmp_f,false,text);
}


void CreateAndSave(){
    ClearScreen();
    printf("\n\n\n\n\033[1;30;47mSAVE FILE AS?\033[0m\n->");
    char ch[500];
    scanf("%s", ch);
    FILE *tmp_f = fopen("temp.txt","r");
    FILE *file = fopen(ch, "w");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }
    while (true) {
        char c = fgetc(tmp_f);
        if (c == EOF) {
            break;
        } else {
            fputc(c, file);
        }
    }
    fclose(file);
    fclose(tmp_f);
    remove("temp.txt");  
    printf("\n\033[1;30;47mSAVED SUCESSFULLY\033[0m\n"); 
}



void ReadAndSave(){

    FILE *tmp_f = fopen("temp.txt","r");
    FILE *file = fopen(read_path, "w");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }

    while (true) {
        char c = fgetc(tmp_f);
        if (c == EOF) {
            break;
        } else {
            fputc(c, file);
        }
    }
    fflush(file); 
    remove("temp.txt");
    printf("\n\033[1;30;47mSAVED SUCESSFULLY\033[0m\n");
}




void RemoveChar(char **text){
    size_t len = strlen(*text);
    if (len > 0) {
        (*text)[len - 1] = '\0';
        *text = realloc(*text, len);
    }
}




void append(char **wrd1, char wrd2) {
    size_t len1 = strlen(*wrd1);  
    *wrd1 = realloc(*wrd1, len1 + 2*sizeof(wrd2));  
    if (*wrd1 == NULL) {
        perror("Failed to reallocate memory");
        exit(1);
    }
    (*wrd1)[len1] = wrd2;    
    (*wrd1)[len1 + 1] = '\0';   
}

char* GetUndoRedo(char * txt) {
    char k[15] = "Cache/";
    char m[3];
    sprintf(m, "%d", c_file_pointer);
    strcat(k, m);
    strcat(k, ".txt");
    
    FILE *f = fopen(k, "r");
    if (!f) {
        f = fopen(k, "w");
        fwrite(txt, 1, strlen(txt), f);
        fclose(f);
        f = fopen(k, "r");
    }
    fseek(f, 0, SEEK_END);
    long length = ftell(f);
    fseek(f, 0, SEEK_SET);
    
    char *text = malloc(length + 1);
    if (text) {
        fread(text, 1, length, f);
        text[length] = '\0';
    }
    
    fclose(f);
    return text;
}


void StartWriting(FILE *file, bool IsNewfile, char *y) {

    int ascii_val;
    set_raw_mode();

    int undoredosavetime = 0;

    char *text;
    if (IsNewfile) {
        text = malloc(1);
        text[0] = '\0';
    } else {
        text = strdup(y);  // Duplicate initial text to avoid accidental modifications
    }
    
    char *last_displayed_text = malloc(1);
    last_displayed_text[0] = '\0';
    
    if (IsNewfile) {
        SplitWrds(text);
    }

    while (1) {
        ascii_val = getchar();
        char character = ascii_val;

        if (ascii_val == 27) { // Arrow Key Disable
            getchar();
            getchar();
        }
        else if (ascii_val == 12) { // CTRL L for redo
            if (c_file_pointer < 20 && c_file_pointer != ls_file_pointer) {
                c_file_pointer++;
            }
            if (c_file_pointer >= 20) {
                c_file_pointer = 0;
            }

            char *new_text = GetUndoRedo(text);
            if (new_text) {
                free(text);
                text = strdup(new_text);
                
                if (file) fclose(file);
                file = fopen("temp.txt", "w");
                
                if (!file) {
                    perror("Error reopening file after redo");
                    break;
                }
                fwrite(text, 1, strlen(text), file);
                fflush(file);
            }
        }
        // undo
        else if (ascii_val == 11) { //CTRL K
            if (c_file_pointer > 1 && c_file_pointer != ls_file_pointer + 1) {
                c_file_pointer--;
            }
            if(c_file_pointer == 1 && access("Cache/20.txt", F_OK) == 0)
            {
                c_file_pointer = 20;
            }
            char *new_text = GetUndoRedo(text);
            if (new_text) {
                free(text);
                text = strdup(new_text);
            }
        }
        else if (ascii_val == 24) { // Ctrl + X 
            printf("\n\n\n\n\033[1;30;47mSAVE CHANGES BEFORE CLOSING?(y/n)\033[0m\n->");
            char ch = getchar();
            if (ch == 'y' || ch == 'Y') {
                for(int i=0;i<20;i++){
                    char k[15] = "Cache/";
                    char m[3];
                    sprintf(m, "%d", i);
                    strcat(k, m);
                    strcat(k, ".txt");
                    remove(k);
                }
                if (IsNewfile) {
                    fclose(file);
                    ClearScreen();
                    reset_terminal_mode();
                    CreateAndSave();
                    break;
                } else {
                    reset_terminal_mode();
                    fclose(file);
                    ReadAndSave();
                    break;
                }

            } else {
                for(int i=0;i<21;i++){
                    char k[15] = "Cache/";
                    char m[3];
                    sprintf(m, "%d", i);
                    strcat(k, m);
                    strcat(k, ".txt");
                    remove(k);
                }
                break;
            }
        }
        else if (ascii_val == 32) { // Spacebar
            fputc(' ', file);
            append(&text, ' ');
        }
        else if (ascii_val == 127) { // Backspace
            if (ftell(file) > 0) {
                fseek(file, -1, SEEK_END);
                RemoveChar(&text);
                ftruncate(fileno(file), ftell(file));
            }
        }
        else if (ascii_val == 8) {
            printf("\n\n\n\n\033[1;30;47mENTER TERM TO SEARCH:\033[0m\n->");
            reset_terminal_mode();
            scanf("%s", search_terms);
            set_raw_mode();
        }
        else {
            fputc(character, file);
            append(&text, character);
            undoredosavetime++;
        }

        // Update display if text changes
        if (strcmp(last_displayed_text, text) != 0) {
            ClearScreen();
            free(last_displayed_text);
            last_displayed_text = strdup(text);
            SplitWrds(text);
        }

        // Save undo redo  every 10 char
        if (undoredosavetime > 1) {
            SaveUndoRedo(text);
            undoredosavetime = 0;
        }
    }

    // Final cleanup
    free(last_displayed_text);
    free(text);
    reset_terminal_mode();
}

int main() {
    set_raw_mode();
    printf("%s","{Enter the corresponding serial no to perform actions}\n\nTEXT EDITOR\n===========\n1.CREATE FILE\n2.READ FILE\n->");
    char op = getchar();
    reset_terminal_mode();
    switch (op)
    {
    case '1':
        ClearScreen();
        StartWriting(fopen("temp.txt","w"),true,NULL);
        break;
    case '2':
        ReadFile();
        break;
    default:
        
        break;
    }
    return 0;
}


