
/*Implémentation liste chainée*/

typedef struct t_liste {
  double info;
  struct t_liste *suivant;
} Cellule, *Liste;

/* Test de vacuité */

int isEmpty(Liste liste);

/* Constructeur */

Liste newList(double head, Liste tail);

/* Affichage */

void printList(Liste liste);

/*longueur liste*/
int listLength(Liste liste);

/* somme liste */

double sumList(Liste liste);

Liste invertList(Liste liste);

/*Recherche de la présence d'un élement*/
int search(Liste liste, double e);

/*Suppression de tous les élements e d'une liste*/
Liste delete(double e, Liste liste);
