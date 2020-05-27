/***
 Purpose: provides one possible phonetic transcription of the string of
 letters entered according to English spelling and phonetic rules. Some
 combinations of letters are disallowed according to English spelling
 convention or for simplicity's sake.
***/

%{
#include <iostream>
#include <map>
#include <cstring>
#include <string>
#include <stdio.h>

extern "C" int yylex();
extern "C" int yyparse();

void yyerror(const char *s){
   fprintf (stderr, "%s\n", s);
 }

// Helper function to compare const char * for map iterator
class StrCompare {
public:
  bool operator ()(const char*a, const char*b) const {
	return strcmp(a,b) < 0;
  }
};

std::map<char*, int, StrCompare> var_to_int;

const char *pastV[113] = {"thought","struck","hid","drove","sat","meant","undid","ran","arose","chose","told","forgave","kept","got","overcame","snuck","stood","woke","slept","shot","wore","flung","strode","misunderstood","caught","rose","crept","held","stunk","lost","became","shook","upheld","drew","fell","came","swam","threw","sank","blew","repaid","paid","spent","went","spun","retold","awoke","overshot","withheld","sprung","swore","hung","spat","laid","fought","made","tore","dug","dealt","shrank","took","heard","wept","forgot","drank","brought","sent","broke","gave","forbade","sung","began","knelt","stuck","built","froze","sprang","sought","understood","dreamt","felt","underwent","rode","left","beheld","slung","swept","ate","sunk","bit","leapt","grew","overtook","met","stung","sang","knew","flew","found","rung","sold","overheard","won","bought","withdrew","lit","lent","wove","wrote","said","swum","slid","spoke"};
const char *rootV[113] = {"think","strike","hide","drive","sit","mean","undo","run","arise","choose","tell","forgive","keep","get","overcome","sneak","stand","wake","sleep","shoot","wear","fling","stride","misunderstand","catch","rise","creep","hold","stink","lose","become","shake","uphold","draw","fall","come","swim","throw","sink","blow","repay","pay","spend","go","spin","retell","awake","overshoot","withhold","spring","swear","hang","spit","lay","fight","make","tear","dig","deal","shrink","take","hear","weep","forget","drink","bring","send","break","give","forbid","sing","begin","kneel","stick","build","freeze","spring","seek","unsterstand","dream","feel","undergo","ride","leave","behold","sling","sweep","eat","sink","bite","leap","grow","overtake","meet","sting","sing","know","fly","find","ring","sell","overhear","win","buy","withdraw","light","lend","weave","write","say","swim","slide","speak"};

const char caps[27] = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
const char lower[27] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
%}

/*** union of all possible data return types from grammar ***/
%union {
	char* sVal;
    char** sArr;
}


/*** Define token identifiers for flex regex matches ***/

%token EOL
%token SP
%token PREPWHAT
%token PREPWHERE
%token PREPHOW
%token PREPWHY
%token PREPWHEN
%token MODAL
%token PRONWHO
%token PRONWHAT
%token PRONWHOSE
%token PRONWHERE
%token DET
%token NOT
%token THAT
%token THIS
%token TO
%token COMP
%token CONJ
%token NEG
%token ED
%token VERBPAST
%token VERBS
%token VERBES
%token VERB
%token ADVHOW
%token ADVWHEN
%token ADJ
%token NOUNWHAT
%token NOUNWHO
%token GER

/*** Define return type for grammar rules ***/

%type<sVal>EOL
%type<sVal>SP
%type<sVal>PREPWHAT
%type<sVal>PREPWHERE
%type<sVal>PREPHOW
%type<sVal>PREPWHY
%type<sVal>PREPWHEN
%type<sVal>MODAL
%type<sVal>PRONWHO
%type<sVal>PRONWHAT
%type<sVal>PRONWHOSE
%type<sVal>PRONWHERE
%type<sVal>DET
%type<sVal>NOT
%type<sVal>THAT
%type<sVal>THIS
%type<sVal>TO
%type<sVal>COMP
%type<sVal>CONJ
%type<sVal>NEG
%type<sVal>ED
%type<sVal>VERBPAST
%type<sVal>VERBS
%type<sVal>VERBES
%type<sVal>VERB
%type<sVal>ADVHOW
%type<sVal>ADVWHEN
%type<sVal>ADJ
%type<sVal>NOUNWHAT
%type<sVal>NOUNWHO
%type<sVal>GER

%type<sArr>sentence
%type<sVal>statement
%type<sVal>conjdp
%type<sVal>dp
%type<sVal>det
%type<sVal>nconjmp
%type<sVal>nmp
%type<sVal>nmodal
%type<sVal>np
%type<sVal>adjp
%type<sVal>adj
%type<sVal>nomp
%type<sVal>noun
%type<sVal>pronoun
%type<sVal>ncp
%type<sVal>ncomp
%type<sVal>pp
%type<sVal>prep
%type<sVal>advp
%type<sVal>adv
%type<sVal>nconjvp
%type<sVal>nvp
%type<sVal>nverb
%type<sArr>mp
%type<sVal>modal
%type<sArr>vp
%type<sArr>verb
%type<sArr>verba
%type<sArr>verbb
%type<sVal>whatp
%type<sVal>nounwhat
%type<sVal>npwhat
%type<sVal>nompwhat
%type<sVal>whatnoun
%type<sVal>whop
%type<sVal>npwho
%type<sVal>nompwho
%type<sVal>whonoun
%type<sVal>wherep
%type<sVal>whyp
%type<sVal>whenp
%type<sVal>howp
%type<sVal>whosep
%type<sVal>cp
%type<sVal>comp

%%

begin: sentence EOL {
        char space[] = " ";
        char qmark[] = "?";
        char* sent;
		sent = (char*)malloc(strlen($1[0])+strlen($1[1])+strlen($1[2])+strlen($1[3])+5);
        strcpy(sent, $1[3]);
        strcat(sent, space);
        strcat(sent, $1[1]);
        strcat(sent, space);
        strcat(sent, $1[0]);
        if($1[2][0] != 0){
            strcat(sent, space);
            strcat(sent, $1[2]);
        }
        strcat(sent, qmark);
        
        printf("%s\n\n", sent);
			 } begin
	 | /* NULL */
	 ;

sentence: conjdp mp {
            $$ = (char**)calloc(4, sizeof($1));
            
            $$[0] = (char*)malloc(strlen($1)+1);
            $$[1] = (char*)malloc(strlen($2[0])+1);
            $$[2] = (char*)malloc(strlen($2[1])+1);
            $$[3] = (char*)malloc(strlen($2[2])+1);
            
            int i = 0;
            while(i <27){
                if (caps[i]==$1[0]){
                    if (($1[0] != 'I')|(($1[1] != ' ')&($1[1] != '\0'))){
                        $1[0] = lower[i];
                    }
                }
                i++;
            }
            
            strcpy($$[0], $1);
            strcpy($$[1], $2[0]);
            strcpy($$[2], $2[1]);
            strcpy($$[3], $2[2]);
         }
         
statement: conjdp nconjmp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+2);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
         }
         
         
conjdp: conjdp CONJ SP dp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
      }
      | dp

dp: det np {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  } 
  | np {
        $$ = (char*)malloc(strlen($1)+1);
        strcat($$, $1);
  }

det: DET SP {
        $$ = $1;
    }
    | THAT SP {
        $$ = $1;
    }
    | THIS SP {
        $$ = $1;
    }
  
np: adjp nomp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  }
  | nomp

nomp: noun
    | pronoun
    | noun ncp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    | noun pp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    
noun: NOUNWHO SP {
        $$ = $1;
    }
    | NOUNWHAT SP {
        $$ = $1;
    }
    | GER SP {
        $$ = $1;
    }
    
pronoun: PRONWHO SP {
        $$ = $1;
        }
        | PRONWHAT SP {
            $$ = $1;
        }
        | PRONWHERE SP {
            $$ = $1;
        }
        | THIS SP {
            $$ = $1;
        }
        | THAT SP {
            $$ = $1;
        }

ncp: ncomp statement {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
 }
 | ncomp nconjmp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
 }

ncomp: COMP SP {
        $$ = $1;
    }
    | THAT SP {
        $$ = $1;
    }
  
pp: pp CONJ SP prep conjdp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+strlen($5)+4);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $4);
        strcat($$, space);
        strcat($$, $5);
  }
  | prep conjdp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  }

prep: PREPHOW SP {
        $$ = $1;
    }
    | PREPWHAT SP {
        $$ = $1;
    }
    | PREPWHEN SP {
        $$ = $1;
    }
    | PREPWHERE SP {
        $$ = $1;
    }
    | PREPWHY SP {
        $$ = $1;
    }
    | TO SP {
        $$ = $1;
    }

adjp: adjp adj {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    | advp adj {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+3);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    | adjp CONJ SP adj {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $4);
    }
    | adj

adj: ADJ SP {
        $$ = $1;
    }
    | GER SP {
        $$ = $1;
    }
    | ED SP {
        $$ = $1;
    }

nconjmp: nconjmp CONJ SP nmp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
      }
      | nmp
  
nmp: nmodal nconjvp {
        char space[] = " ";
        $$ = (char*)malloc(+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        
  }
  | nmodal advp nconjvp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($3)+3);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $3);
        
  }
  | nconjvp 

advp: advp adv SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    | advp CONJ SP adv SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $4);
    }
    | adv
    
adv: ADVHOW SP {
        $$ = $1;
    }
    | ADVWHEN SP {
        $$ = $1;
    }
  
nmodal: MODAL SP {
        $$ = $1;
    }
    | TO SP {
        $$ = $1;
    }
    | MODAL SP NOT SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($3)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $3);
    }
    | NOT SP TO SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($3)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $3);
    }
  
nconjvp: nconjvp CONJ SP nvp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
      }
      | nvp
  
nvp: nverb pp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  }
  | nverb nconjmp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        
  }
  | nverb conjdp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        
  }
  | nverb cp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  }
  | nverb adjp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  }
  | nverb advp {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
  }
  | nverb 
  
    
  
nverb: VERB SP {
        $$ = $1;
    }
    | VERBPAST SP {
        $$ = $1;
    }
    | VERBS SP {
        $$ = $1;
    }
    | VERBES SP {
        $$ = $1;
    }
    | MODAL SP {
        $$ = $1;
    }
    | MODAL SP NOT SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($3)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $3);
    }
    | GER SP {
        $$ = $1;
    }
    | ED SP {
        $$ = $1;
    }

mp: modal vp {
        $$ = (char**)calloc(3, (sizeof($2[0])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1)+1);
        $$[1] = (char*)malloc(strlen($2[0])+1);
        $$[2] = (char*)malloc(strlen($2[1])+1);
        
        strcpy($$[0], $1);
        strcpy($$[1], $2[1]);
        strcpy($$[2], $2[2]);
  }
  | vp {
        $$ = (char**)calloc(3, (sizeof($1[0])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen($1[2])+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], $1[2]);
  }

modal: MODAL SP {
        $$ = $1;
    }
    | MODAL SP NOT SP {
        char space[] = " ";
        char neg[]= "n\'t";
        $$ = (char*)malloc(strlen($1)+strlen(neg)+1);
        strcpy($$, $1);
        strcat($$, neg);
    }

  
vp: advp verb {
        char adv[] = "How";
        $$ = (char**)calloc(3, (sizeof($2[0])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($2[0])+1);
        $$[1] = (char*)malloc(strlen($2[1])+1);
        $$[2] = (char*)malloc(strlen(adv)+1);
        
        strcpy($$[0], $2[0]);
        strcpy($$[1], $2[1]);
        strcpy($$[2], adv);
   }
   | verb whatp {
        char what[] = "What";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(what)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], what);
  }
  | verb wherep {
        char where[] = "Where";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(where)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], where); 
  }
  | verb whenp {
        char when[] = "When";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(when)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]); 
        strcpy($$[2], when);
  }
  | verb whop {
        char who[] = "Who";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(who)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], who); 
  }
  | verb whyp {
        char why[] = "Why";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(why)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], why); 
  }
  | verb howp {
        char how[] = "How";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(how)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], how); 
  }
  | verb whosep {
        char whose[] = "Whose";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen(whose)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], whose); 
  }
  | verb cp {
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen($1[1])+1);
        $$[2] = (char*)malloc(strlen($2)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], $1[1]);
        strcpy($$[2], $2); 
  }
  | verb  {
        char what[] = "What";
        char d[] = "do";
        $$ = (char**)calloc(3, (sizeof($1[1])+sizeof(char)*5));
        
        $$[0] = (char*)malloc(strlen($1[0])+1);
        $$[1] = (char*)malloc(strlen(d)+1);
        $$[2] = (char*)malloc(strlen(what)+1);
        
        strcpy($$[0], $1[0]);
        strcpy($$[1], d);
        strcpy($$[2], what); 
  }

whatp: THAT SP statement {
        $$ = $1;
    }
     | PREPWHAT SP conjdp {
        $$ = $1;
    }
     | PREPWHAT SP statement {
        $$ = $1;
    }
     | nounwhat
     | nconjmp 
     | THAT SP {
        $$ = $1;
    }
     | THIS SP {
        $$ = $1;
    }
     
nounwhat: det npwhat {
        $$ = $1;
    }
        | npwhat
  
npwhat: adjp nompwhat {
        $$ = $1;
    }
      | nompwhat

nompwhat: whatnoun
        | whatnoun cp {
        $$ = $1;
    }
        | whatnoun pp {
        $$ = $1;
    }

whatnoun: PRONWHAT SP {
        $$ = $1;
    }
        | NOUNWHAT SP {
        $$ = $1;
    }
     
wherep: PREPWHERE SP conjdp {
        $$ = $1;
    }
      | PREPWHERE SP statement {
        $$ = $1;
    }
      | TO SP conjdp {
        $$ = $1;
    }
      | TO SP statement {
        $$ = $1;
    }
      | PRONWHERE SP {
        $$ = $1;
    }

whop: det npwho {
        $$ = $1;
    }
    | npwho
  
npwho: adjp nompwho {
        $$ = $1;
    }
     | nompwho

nompwho: whonoun
       | whonoun cp {
        $$ = $1;
    }
       | whonoun pp {
        $$ = $1;
    }

whonoun: PRONWHO SP {
        $$ = $1;
    }
       | NOUNWHO SP {
        $$ = $1;
    }

whyp: PREPWHY SP conjdp {
        $$ = $1;
    }
    | PREPWHY SP statement {
        $$ = $1;
    }
    
whenp: PREPWHEN SP conjdp {
        $$ = $1;
    }
     | PREPWHEN SP statement {
        $$ = $1;
    }
     | ADVWHEN SP {
        $$ = $1;
    }
     
howp: PREPHOW SP conjdp {
        $$ = $1;
    }
    | PREPHOW SP statement {
        $$ = $1;
    }
    | ADVHOW SP {
        $$ = $1;
    }
    | adjp
    
whosep: PRONWHOSE SP

cp: comp statement {
        $$ = $1;
 }
 | comp nconjmp {
        $$ = $1;
 }

comp: COMP SP {
        int i = 0;
        while(i<27){
            if(lower[i] == $1[0]){
                $1[0] = caps[i];
            }
            i++;
        }
        $$ = $1;
    }
    | THAT SP {
        char what[] = "What";
        $$ = what;
    }

verb: verba
    | verbb


verba: VERB SP {
        char d[] = "do";
        $$ = (char**)calloc(2, (sizeof($1)+sizeof(d)));
        
        $$[0] = (char*)malloc(strlen(d)+1);
        $$[1] = (char*)malloc(strlen($1)+1);
        
        strcpy($$[0], d);
        strcpy($$[1], $1);
    }
    | GER SP {
        char d[] = "do";
        $$ = (char**)calloc(2, (sizeof($1)+sizeof(d)));
        
        $$[0] = (char*)malloc(strlen(d)+1);
        $$[1] = (char*)malloc(strlen($1)+1);
        
        strcpy($$[0], d);
        strcpy($$[1], $1);
    }
    | ED SP {
        char did[] = "did";
        $1[strlen($1)-2] = '\0';
        $$ = (char**)calloc(2, (sizeof($1)+sizeof(did)));
        
        $$[0] = (char*)malloc(strlen(did)+1);
        $$[1] = (char*)malloc(strlen($1)+1);
        
        strcpy($$[0], did);
        strcpy($$[1], $1);
    }
    | VERBS SP {
        char does[] = "does";
        $1[strlen($1)-1] = '\0';
        $$ = (char**)calloc(2, (sizeof($1)+sizeof(does)));
        
        $$[0] = (char*)malloc(strlen(does)+1);
        $$[1] = (char*)malloc(strlen($1)+1);
        
        strcpy($$[0], does);
        strcpy($$[1], $1);
    }
    | VERBES SP {
        char does[] = "does";
        $1[strlen($1)-2] = '\0';
        $$ = (char**)calloc(2, (sizeof($1)+sizeof(does)));
        
        $$[0] = (char*)malloc(strlen(does)+1);
        $$[1] = (char*)malloc(strlen($1)+1);
        
        strcpy($$[0], does);
        strcpy($$[1], $1);
    }
    | VERBPAST SP {
        char did[] = "did";
        char *v;
        v = (char*)malloc(strlen($1)+5);
        int i = 0;
        while(i < 113) {
            if (strcmp(pastV[i], $1) == 0){
                strcpy(v, rootV[i]);
                break;
            }
            i++;
        }
        $$ = (char**)calloc(2, (sizeof(v)+sizeof(did)));
        
        $$[0] = (char*)malloc(strlen(did)+1);
        $$[1] = (char*)malloc(strlen(v)+1);
        
        strcpy($$[0], did);
        strcpy($$[1], v);
    } 

verbb: MODAL SP {
        $$ = (char**)calloc(2, (sizeof($1)));
        
        $$[0] = (char*)malloc(strlen($1)+1);
        $$[1] = (char*)malloc(strlen($1)+1);
        
        strcpy($$[0], $1);
    }
%%

int main(int argc, char **argv) {
	yyparse();
}

/* Display error messages */
void yyerror(char *s) {
	printf("ERROR: %s\n", s);
}
