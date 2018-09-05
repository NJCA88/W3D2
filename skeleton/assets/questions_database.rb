require 'sqlite3'
require 'singleton'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Question.new(question.last)
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

end

class User

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    User.new(user.last)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end
# require 'byebug'
class QuestionFollows
  def self.find_by_id(question_id)

    question_following =
     QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          question_id = ?
    SQL
    # debugger
    QuestionFollows.new(question_following.last)
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end

class Replies

  def self.find_by_id(reply_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Replies.new(replies)
  end

  def initialize(options)
    @id = options['id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
    @question_id = options['question_id']
    @author_id = options['author_id']
  end
end

class QuestionLikes
  def self.find_by_question_id(question_id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.question_id = ?
    SQL
end
