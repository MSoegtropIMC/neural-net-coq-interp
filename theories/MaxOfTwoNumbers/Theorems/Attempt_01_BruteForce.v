From Coq Require Import Floats Sint63 Uint63 QArith Lia List PArray Derive.
From NeuralNetInterp.Torch Require Import Tensor Einsum Slicing.
From NeuralNetInterp.Util Require Import Pointed.
From NeuralNetInterp.Util.Arith Require Import Classes Instances FloatArith.Definitions.
From NeuralNetInterp.Torch Require Import Tensor.Instances.
From NeuralNetInterp.MaxOfTwoNumbers Require Import Parameters Model Heuristics TheoremStatement Model.Instances.
From NeuralNetInterp.MaxOfTwoNumbers.Computed Require Import AllLogits.
Local Open Scope uint63_scope.
Local Open Scope core_scope.

Derive computed_accuracy SuchThat (computed_accuracy = real_accuracy) As computed_accuracy_eq.
Proof.
  cbv [real_accuracy].
  etransitivity; revgoals.
  { apply Tensor.item_Proper; intro.
    eapply Model.acc_fn_Proper; repeat intro; subst; [ | reflexivity .. ].
    apply all_tokens_logits_eq. }
  Time vm_compute; reflexivity.
Defined.

Compute abs (computed_accuracy - expected_accuracy). (*      = 0.0023193359375%float *)
Compute (abs (computed_accuracy - expected_accuracy) * totalf)%float. (* = 19 *) (* probably from floating point assoc issues, etc *)
Compute Qred (PrimFloat.to_Q (computed_accuracy * totalf)) / Qred (PrimFloat.to_Q totalf). (*      = 8154 # 8192 *)
Theorem good_accuracy : TheoremStatement.Accuracy.best (* (abs (real_accuracy - expected_accuracy) <? error)%float = true *).
Proof.
  rewrite <- computed_accuracy_eq.
  vm_compute; reflexivity.
Qed.
