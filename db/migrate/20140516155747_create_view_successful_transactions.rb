class CreateViewSuccessfulTransactions < ActiveRecord::Migration
  def up
    query = <<-SQL
      SELECT p.id, psub.user_id, 'payments' as relname
      FROM payments p
      JOIN subscriptions psub ON psub.id = p.subscription_id
      WHERE p.state = 'finished' OR p.state = 'authorized'
      UNION ALL
      SELECT i.id, isub.user_id, 'invoices' as relname
      FROM invoices i
      JOIN subscriptions isub ON isub.id = i.subscription_id
      WHERE i.status = 'finished'
    SQL

    create_view(:successful_transactions, query)
  end

  def down
    drop_view :successful_transactions
  end
end
