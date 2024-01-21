abstract class CashRepository {
  Future<int> getCashAmount();
  Future<void> setCashAmount(int newAmount);
}