play = 0
first_player_tally = 0
second_player_tally = 0


class BaseHand

	RANK = {
	  '2' => 2,
	  '3' => 3,
	  '4'=> 4,
	  '5' => 5,
	  '6' => 6,
	  '7' => 7,
	  '8' => 8,
	  '9' => 9,
	  'T' => 10,
	  'J' => 11,
	  'Q' => 12,
	  'K' => 13,
	  'A' => 14
	}

	def check_winner(hands)

		hands.map do |hand| 
			hand[:winning_hand] = winning_text
			hand
		end

		if hands.length == 2
			return tie_breaker(hands) || { tie: true, hands: hands }
		end

		if hands.length == 1
			return hands[0]
		end

	end

	def three_of_a_kind_tie_breaker(hands)
		first_hand_highest = hands[0][:of_a_kind][3][0]
		second_hand_highest = hands[1][:of_a_kind][3][0]
		first_hand_highest > second_hand_highest ? hands[0] : hands[1]
	end

	def next_highest_card(hands)
		hand_one = hands[0][:ranks].reverse
		hand_two = hands[1][:ranks].reverse
		highest_card = nil
		hand_one.each_with_index { |card, index| 
			if card != hand_two[index]
				if card > hand_two[index]
					highest_card = hands[0]
				else
					highest_card = hands[1]
				end

				break
				
			end
			
		 }
		highest_card
	end

end


class RoyalFlush < BaseHand

  def is_royal_flush(hand)
		royal_flush = hand[:flush] && hand[:straight] && hand[:ranks][0] == 10
		royal_flush
	end

	def royal_flush_tie_breaker(hands)

	end

	def filtered(hands)
		hands.select { |hand| is_royal_flush(hand) }
	end

	def tie_breaker(hands)
		royal_flush_tie_breaker(hands)
	end

	def winning_text
		"Royal Flush"
	end

end


class StraightFlush < BaseHand

	#Straight Flush: All cards are consecutive values of same suit.
	def is_straight_flush(hand)
		straight_flush = hand[:flush] && hand[:straight]
		straight_flush
	end

  def filtered(hands)
  	hands.select { |hand| is_straight_flush(hand) }
	end

	def tie_breaker(hands)
		next_highest_card(hands)
	end

	def winning_text
		"Straight Flush"
	end

end


class FourOfAKind < BaseHand

	#Four of a Kind: Four cards of the same value.
	def is_four_of_a_kind(hand)
		four_of_a_kind = hand[:of_a_kind][4]
		four_of_a_kind
	end
	def four_of_a_kind_tie_breaker(hands)
		first_hand_highest = hands[0][:of_a_kind][4][0]
		second_hand_highest = hands[1][:of_a_kind][4][0]
		first_hand_highest > second_hand_highest ? hands[0] : hands[1]
	end

	def filtered(hands)
  		hands.select { |hand| is_four_of_a_kind(hand) }
	end

	def tie_breaker(hands)
		four_of_a_kind_tie_breaker(hands)
	end

	def winning_text
		"Four of a kind"
	end

end


class FullHouse < BaseHand

	#Full House: Three of a kind and a pair.
	def is_full_house(hand)
		full_house = hand[:of_a_kind][3] && hand[:of_a_kind][2]
		full_house
	end

	def filtered(hands)
		hands.select { |hand| is_full_house(hand) }
	end

	def tie_breaker(hands)
		three_of_a_kind_tie_breaker(hands)
	end

	def winning_text
		"Full House"
	end

end


class Flush < BaseHand

	#Flush: All cards of the same suit.
	def is_flush(hand)
		flush = hand[:flush]
		flush
	end

	def filtered(hands)
		hands.select { |hand| is_flush(hand) }
	end

	def tie_breaker(hands)
		next_highest_card(hands)
	end

	def winning_text
		"Flush"
	end

end


class Straight < BaseHand

	#Straight: All cards are consecutive values.
	def is_straight(hand)
		straight = hand[:straight]
		straight
	end

	def filtered(hands)
		hands.select { |hand| is_straight(hand) }
	end

	def tie_breaker(hands)
		next_highest_card(hands)
	end

	def winning_text
		"Straight"
	end

end


class ThreeOfAKind < BaseHand

	#Three of a Kind: Three cards of the same value.
	def is_three_of_a_kind(hand)
		three_of_a_kind = hand[:of_a_kind][3]
		three_of_a_kind
	end

	def filtered(hands)
		hands.select { |hand| is_three_of_a_kind(hand) }
	end

	def tie_breaker(hands)
		three_of_a_kind_tie_breaker(hands)
	end

	def winning_text
		"Three of a kind"
	end

end


class TwoPair < BaseHand

	#Two Pairs: Two different pairs.
	def is_two_pair(hand)
		two_pair = hand[:of_a_kind][2] && hand[:of_a_kind][2].length == 2
		two_pair
	end

	def two_pair_tie_breaker(hands)
		first_pair = hands[0][:of_a_kind][2].sort.reverse
		second_pair = hands[1][:of_a_kind][2].sort.reverse
		tie_breaker = nil

		first_pair.each_with_index { |card, index| 
			if card != second_pair[index]
				if card > second_pair[index]
					tie_breaker = hands[0]
				else
					tie_breaker = hands[1]
				end
				break
				
			end
		}
		tie_breaker
	end

	def filtered(hands)
		hands.select { |hand| is_two_pair(hand) }
	end

	def tie_breaker(hands)
		two_pair_tie_breaker(hands)
	end

	def winning_text
		"Two pair"
	end

end


class OnePair < BaseHand

	#One Pair: Two cards of the same value.
	def is_one_pair(hand)
		one_pair = hand[:of_a_kind][2] && hand[:of_a_kind][2].length == 1
		one_pair
	end

	def one_pair_tie_breaker(hands)
		first_pair = hands[0][:of_a_kind][2][0]
		second_pair = hands[1][:of_a_kind][2][0]
		if first_pair === second_pair
		  return next_highest_card(hands)
		end
		first_pair > second_pair ? hands[0] : hands[1]
	end

	def filtered(hands)
		hands.select { |hand| is_one_pair(hand) }
	end

	def tie_breaker(hands)
		one_pair_tie_breaker(hands)
	end

	def winning_text
		"Pair"
	end

end


class HighCard < BaseHand

	def filtered(hands)
		hands
	end

	def tie_breaker(hands)
		next_highest_card(hands)
	end

	def winning_text
		"High Card"
	end

end


class Game

	ORDER = [RoyalFlush.new, StraightFlush.new, FourOfAKind.new, FullHouse.new, Flush.new, Straight.new, ThreeOfAKind.new, TwoPair.new, OnePair.new, HighCard.new]

	def get_props(hand, index)
		props = {
			player: index+1,
			hand: hand,
			ranks: rank(hand),
			flush: flush(hand), 
		}
		props[:straight] = straight(props[:ranks])
		props[:of_a_kind] = of_a_kind(props[:ranks])
		props
	end

	def rank(hand)
	  ranks = hand.map { |card| BaseHand::RANK[card[0]] }.sort
	  ranks 
	end

	def flush(hand)
		flush = hand.all? { |card| card[1] == hand[0][1] }
		flush
	end

	def straight(ranks)
		if ranks == [2,3,4,5,14] #if Ace needs to precede the other cards for a 'straight'
			straight = true
		else
	    straight = ranks.each_with_index.all? { |rank, i| i < 4 ? ranks[i+1] - rank == 1 : true }
	  end
	   straight
	end

	def of_a_kind(ranks)
		single_kind = Hash.new 0
		ranks.each do |card|
			single_kind[card] += 1
		end
		#stackoverflow.com/questions/10989259/swapping-keys-and-values-in-a-hash
		kind = single_kind.each_with_object( {} ) { |(key, value), out| (out[value] ||= [] ) << key }
		kind
	end

	def find_winner(hands)
		winning_hand = nil
	
		ORDER.each do |hand_type| 
			filtered = hand_type.filtered(hands)
			if filtered.any?
				winning_hand = hand_type.check_winner(filtered)
				break
			end
		end
		winning_hand || { tie: true, hands: hands }
	end
end

G = Game.new
File.foreach('poker.txt') do |line|
  game = line.split(' ')
  first_player_cards = game.first(5)
  second_player_cards = game.last(5)
  play +=1
  puts 'Play: ' + play.to_s
  puts "First player's cards: " + first_player_cards.to_s
  puts "Second player's cards: " + second_player_cards.to_s
  hand_props = [first_player_cards, second_player_cards].each_with_index.map { |hand, i| G.get_props(hand, i)}
  winner = G.find_winner(hand_props)

  if winner[:tie]
  	puts 'Both players tie with '+ winner[:hands][0][:winning_hand]+'!'
  else
  	winner[:player] < 2 ? first_player_tally += 1 : second_player_tally += 1
  	puts 'Player '+winner[:player].to_s+' wins with a '+winner[:winning_hand]+'!'
  	puts 'Player 1 wins: ' + first_player_tally.to_s + " Player 2 wins: " + second_player_tally.to_s
  	puts ''
  end

end
