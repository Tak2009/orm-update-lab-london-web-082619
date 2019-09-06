require_relative "../config/environment.rb"

class Student

  attr_reader :id, :name, :game

  def initialize(name, grade, id = nil)
    @nanme = name 
    @grade = grade
    @id = id
  end


  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRINARY KEY,
      name STRING,
      grade INTEGER
     )
    SQL

   DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

end

def save
  if @id 
     update
  else
    sql = <<-SQL
    INSEERT INTO students(name, grade)
     VALUE(?,?)
    SQL