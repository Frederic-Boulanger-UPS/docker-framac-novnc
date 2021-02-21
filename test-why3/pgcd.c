//@predicate divides(int a, int b) = exists k. b == k * a ;
//@predicate comdiv(int d, int a, int b) = divides(d, a) && divides(d, b) ;
//@predicate greaterdiv(int g, int a, int b) = forall d. comdiv(d,a,b) -> divides(d, g) ;
//@predicate is_gcd(int g, int a, int b) = comdiv(g, a, b) && greaterdiv(g, a, b) ;
//@lemma gcd_self : forall a. is_gcd(a, a, a) ;
//@lemma comdiv_comm : forall a, b, d. comdiv(d, a, b) <-> comdiv(d, b, a) ;
//@lemma comdiv_ab : forall a, b, d. comdiv(d, a-b, b) -> comdiv(d, a, b) ;
//@lemma comdiv_ba : forall a, b, d. comdiv(d, a, b-a) -> comdiv(d, a, b) ;
//@lemma gcd_comm : forall a, b, g. is_gcd(g, a, b) <-> is_gcd(g, b, a) ;
//@lemma gcd_ab : forall a, b, g. is_gcd(g, a-b, b) -> is_gcd(g, a, b) ;
//@lemma gcd_ba : forall a, b, g. is_gcd(g, a, b-a) -> is_gcd(g, a, b) ;

int pgcd(int a, int b) {
 //@requires a > 0 && b > 0 ;
 //@ensures is_gcd(result, old(a), old(b)) ;
 //@label L ;
  while (a != b) {
    //@invariant a > 0 && b > 0 && forall g. is_gcd(g, a, b) -> is_gcd(g, at(a, L), at(b, L)) ;
    //@variant a + b ;
    if (a < b) {
      b -= a;
    } else {
      a -= b;
    }
  }
  return a;
}
