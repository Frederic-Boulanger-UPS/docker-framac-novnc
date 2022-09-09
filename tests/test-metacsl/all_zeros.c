int A, B, C;
// C is never written
/*@ meta \prop, \name(C_untouched), \targets(\ALL), \context(\writing),
      \separated(\written, &C); */

// A is never written // FAILS
/*@ meta \prop, \name(A_untouched), \targets(\ALL), \context(\writing),
      \separated(\written, &A); */

// A is never written unless C is nonzero
/*@ meta \prop, \name(A_untouched_unless), \targets(\ALL), \context(\writing),
      C == 0 ==> \separated(\written, &A); */

/*@ requires A==100 && B==100;
    assigns A,B; 
    ensures A==100 && B==100 && C==0 || C!=0 && A==C && B==C; */
void bidon(){
  if ( C != 0 ){
    A = C;
    B = C;
  }
}    

/*@ requires \valid ( t +(0.. n -1)) && n >= 0;
  @ assigns \nothing;
  @ ensures \result <==> ( \forall integer i ; 0 <= i < n ==> t [ i ] == 0);
  @*/
int all_zeros(int t[], int n) {
  int k;
  /*@ loop invariant \forall integer i ; 0 <= i < k ==> t [ i ] == 0;
    @ loop invariant 0 <= k <= n;
    @ loop assigns k;
    @ loop variant n-k;
    @*/
  for(k = 0; k < n; k++) 
    if (t[k] != 0) 
      return 0;
  return 1;
}
