require_relative "../config/environment.rb"
# require 'pry'

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name 
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

  def save
    if @id 
      update
    else
      sql = <<-SQL
      INSERT INTO students(name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]

    Student.new(result[1], result[2], result[0])
  end

  def self.new_from_db(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
# binding.pry
    Student.new(result[1], result[2], result[0])
  end


  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, 
        grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

end