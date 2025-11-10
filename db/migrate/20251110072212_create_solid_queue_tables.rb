class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name
      t.text :arguments
      t.string :class_name
      t.datetime :scheduled_at
      t.datetime :finished_at
      t.string :status
      t.text :error

      t.timestamps
      t.index [:queue_name]
      t.index [:scheduled_at]
      t.index [:status]
    end

    create_table :solid_queue_recurring_executions do |t|
      t.string :task_key
      t.datetime :last_execution_at
      t.datetime :next_execution_at

      t.timestamps
      t.index [:task_key], unique: true
    end
  end
end