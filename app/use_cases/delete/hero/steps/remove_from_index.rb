# frozen_string_literal: true

class Delete::Hero::Steps::RemoveFromIndex
  def call(destroyed)
    destroyed.remove_from_index!
    destroyed
  end
end
