class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    DB[:conn].execute(%q(
      INSERT INTO students (name, grade) VALUES (?, ?);
      ), self.name, self.grade
    )

    @id = DB[:conn].execute(%q(
      SELECT MAX(id)
      FROM students 
      WHERE name = ?
        AND grade = ?;
      ), self.name, self.grade
    ).first[0]
  end

  def self.create_table
    DB[:conn].execute(%q(
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    ))
  end

  def self.drop_table
    DB[:conn].execute(%q(
      DROP TABLE students;
    ))
  end

  def self.create(data)
    new_student = self.new(data[:name], data[:grade])
    new_student.save
    new_student
  end

end
