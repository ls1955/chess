# frozen_string_literal: true

class ChessBoardPrompt
  def check
    '                 CHECK'
  end

  def chess_not_find
    <<~PROMPT


        ------------------------------------------
                      No chess there
        ------------------------------------------


    PROMPT
  end

  def current_round_info(board, round, counter)
    <<~PROMPT
        #{board}
        ----------------------------------------
               Current round: #{round}
                    Turn: #{counter}
        Please select a chess piece (Ex: a1)
        Enter 'resign' to forfeit the game
        Enter 'save' to save & quit the game
        ----------------------------------------
    PROMPT
  end

  def identical_place_selected
    <<~PROMPT


        ------------------------------------------
                    Identical place selected
        ------------------------------------------


    PROMPT
  end

  def invalid_input
    <<~PROMPT


        ------------------------------------------
                    Invalid input
        ------------------------------------------


    PROMPT
  end

  def invalid_move
    <<~PROMPT


        ----------------------------------------
                  Invalid move selected
        ----------------------------------------


    PROMPT
  end

  def promotion
    <<~PROMPT


    ------------------------------------------
                Promote the pawn?
      Here is the one time chance for promotion
        To promote it, type in a class name
      Ex: [Pawn, Knight, Rook, Bishop, Queen]
      Type anything else to ignore promotion
    ------------------------------------------


    PROMPT
  end

  def select_destination
    <<~PROMPT

        #{board}
        ----------------------------------------
        Please select the destination (Ex: a1)
        Enter 'redo' to reselect chess piece
        ----------------------------------------

    PROMPT
  end

  def wrong_chess_chosen
    <<~PROMPT


        ------------------------------------------
                      Not your chess
        ------------------------------------------


    PROMPT
  end

  def winner(player)
    <<~PROMPT


      ------------------------------------------
              "Winner is #{player}"
      ------------------------------------------


    PROMPT
  end
end
