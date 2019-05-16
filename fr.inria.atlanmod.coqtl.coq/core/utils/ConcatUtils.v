Require Import List.
Require Import utils.ListUtils.

Lemma concat_map_incl:
  forall (T1 T2: Type) (a: T1) (l: list T1) (f: T1-> (list T2)),
    (In a l) -> incl (f a) (concat (map f l)).
Proof.
  intros.
  induction l.
  - inversion H.
  - destruct H.
    + simpl.
      rewrite H.
      apply incl_appl.
      apply incl_refl.
    + simpl.
      apply IHl in H.
      apply incl_appr.
      exact H.
Qed.

Lemma concat_in:
  forall (T: Type) (el: T) (l0 : list T) (l1 : list (list T)),
    In el l0 -> In l0 l1 -> In el (concat l1).
Proof.
  intros.
  induction l1.
  - inversion H0.
  - simpl.
    simpl in H0.
    apply in_or_app.
    destruct H0.
    + left. rewrite H0. assumption.
    + right. apply IHl1. assumption.
Qed.

Lemma concat_map_option_incl:
  forall (T1 T2: Type) (a: T1) (l: list T1) (f: T1 -> option (list T2)) (lt: list T2),
    (In a l) -> (f a) = Some lt -> 
      incl lt (concat (optionList2List (map f l))).
Proof.
  intros.
  induction l.
  - inversion H.
  - destruct H.
    + simpl.
      rewrite H.
      unfold optionToList.
      rewrite H0.
      simpl.
      apply incl_appl.
      apply incl_refl.
    + simpl.
      apply IHl in H.
      assert 
        ((concat (optionToList (f a0) ++ optionList2List (map f l))) = 
        ((concat (optionToList (f a0))) ++ (concat (optionList2List (map f l))))). 
      { apply concat_app. }
      rewrite H1.
      apply incl_appr.
      exact H.
Qed.


Lemma concat_incl :
    forall (A: Type) (a: list A) (b: list A) (c: list (list A)),
      incl a b -> In b c -> incl a (concat c).
  Proof.
    intros.
    induction c.
    - inversion H0.
    - simpl. simpl in H0.
      destruct H0.
      * rewrite H0.
        apply incl_appl.
        assumption.
      * apply incl_appr.
        apply IHc.
        apply H0.
   Qed.
  
Lemma concat_exists :
    forall (T : Type) (a : T) (l : list (list T)),
      In a (concat l) -> (exists (la : list T), In la l /\ In a la).
Proof.
  intros.
  apply in_flat_map.
  rewrite flat_map_concat_map.
  rewrite map_id.
  assumption.
Qed.

Lemma concat_map_exists :
    forall (T1 T2: Type) (b : T2) (l : list T1) (f : T1 -> list T2),
      In b (concat (map f l)) -> (exists (a : T1), In a l /\ In b (f a)).
Proof.
  intros.
  apply in_flat_map.
  rewrite flat_map_concat_map.
  assumption.
Qed.

Lemma concat_map_option_exists :
    forall (T1 T2: Type) (b : T2) 
           (l : list T1) (f : T1 -> option (list T2)),
      In b (concat (optionList2List (map f l))) -> 
       (exists (a : T1), In a l /\ 
         (match (f a) with
          | None => False
          | Some lst => In b lst
          end)
       ).
Proof.
    intros.
    apply concat_exists in H.
    destruct H. destruct H.
    induction l.
    - inversion H.
    - simpl in H. destruct (f a) eqn: fa. simpl in H. destruct H.
      -- exists a. split. 
         --- simpl. left. reflexivity. 
         --- rewrite fa. rewrite <- H in H0. exact H0.         
      -- apply IHl in H. destruct H. exists x0. destruct H. split. simpl. right. apply H. apply H1.
      -- apply IHl in H. destruct H. exists x0. destruct H. split. simpl. right. apply H. apply H1.
Qed.
