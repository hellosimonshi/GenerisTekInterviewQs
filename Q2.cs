using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace ConsoleApp5
{
    class Program
    {
        static void Main(string[] args)
        {
            //           Console.WriteLine("Hello World!");
            var boad = new TicTacToe(3);

            Console.WriteLine(boad.PlacePiece(0, 0, 1));
            Console.WriteLine(boad.PlacePiece(1, 1, 1));
            Console.WriteLine(boad.PlacePiece(2, 2, 1));

        }
    }

    public class TicTacToe
    {

        /// <summary>
        /// Created a Tic Tac Tow game board
        /// </summary>
        /// <param name="n">nxn dimension for the game board</param>

        int dim = 0;
        Boolean[,] user1;
        Boolean[,] user2;
        static List<Boolean[,]> TicTacRoeBoard = new List<bool[,]>();
        public TicTacToe(int n)
        {
            dim = n;
            user1 = new Boolean[n, n];
            user2 = new Boolean[n, n];

            TicTacRoeBoard.Add(user1);
            TicTacRoeBoard.Add(user2);
        }

        /// <summary>
        /// Place a piece on the game board
        /// </summary>
        /// <param name="row">row to place a piece</param>
        /// <param name="col">column to place a piece</param>
        /// <param name="player">the player (1 or 2) the piece is for</param>
        /// <returns>0 = no winner, 1 = player 1 won, 2 = player 2 won</returns>
        public int PlacePiece(int row, int col, int player)
        {
            var board = TicTacRoeBoard[player-1];

            board[row, col] = true;

            //count row
            for (int i = 0; i < dim; i++)
                if (board[i, col] == false)
                {
                    //count column
                    for (int j = 0; j < dim; j++)
                        if (board[row, j] == false)
                        {
                            //left right diaglog
                            for (int m = 0; m < dim; m++)
                                if(board[m, m] == false)
                                {
                                    //right to left diaglog
                                    for (int n = 0; n < dim; n++)
                                        if (board[n, dim - 1 - n] == false)
                                            return 0;
                                }
                        }
                }

            return player;
        }
    }
}

