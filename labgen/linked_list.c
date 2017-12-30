#include <stdlib.h>
#include <stdio.h>

/*Implémentation liste chainée*/

typedef struct t_liste {
  double info;
  struct t_liste *suivant;
} Cellule, *Liste;



/* Test de vacuité */

int isEmpty(Liste liste){
  if (liste == NULL) return 1;
  else return 0;
}

/* Constructeur */

Liste newList(double head, Liste tail){
  Cellule *c;
  c = (Cellule*)malloc(sizeof(Cellule));
  c->info = head;
  c->suivant = tail;
  return c;
}

/* Affichage */

void printList(Liste liste){
  if(!isEmpty(liste)){
    printf("[%f]->", liste->info);
    printList(liste->suivant);
  }
  else{
    printf("[]\n");
  }
}

/*longueur liste*/
int listLength(Liste liste){
  if(!isEmpty(liste)) return 1 + listLength(liste->suivant);
  else return 0;
}

/* somme liste */

double sumList(Liste liste){
  if(!isEmpty(liste)) return liste->info + sumList(liste->suivant);
  else return 0;
}

Liste invertList(Liste liste) {
  Liste res = NULL;
  while (!isEmpty(liste)) {
      Liste suivant = liste->suivant;
      liste->suivant = res;
      res = liste;
      liste = suivant;
  }
  return res;
}

/*Recherche de la présence d'un élement*/
int search(Liste liste, double e){
  while(!isEmpty(liste)){

    if (e==liste->info){
      return 1;
    }
    liste = liste->suivant;

    }

    return 0;
}

/*Suppression de tous les élements e d'une liste*/
Liste delete(double e, Liste liste){
  Liste res=NULL;

  if(liste->info == e){

    return liste->suivant;

  }

  else{

    while(!isEmpty(liste)){

      if (liste->info != e){
        res = newList(liste->info, res);
      }
      liste = liste->suivant;
    }

    return invertList(res);
  }
}
