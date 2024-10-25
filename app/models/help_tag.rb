class HelpTag < ApplicationRecord
  validates :tag_id, uniqueness: { scope: :help_id, message: "já está alocado na ajuda selecionada." }

  belongs_to :help
  belongs_to :tag
end
