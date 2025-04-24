/*
  # Create listings table and security policies

  1. New Tables
    - `listings`
      - `id` (uuid, primary key)
      - `title` (text)
      - `category` (text)
      - `subcategory` (text)
      - `attributes` (jsonb)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamp)
      - `location` (text)
      - `contact` (text)

  2. Security
    - Enable RLS on `listings` table
    - Add policies for:
      - Anyone can view listings
      - Authenticated users can create listings
      - Users can only update/delete their own listings
*/

CREATE TABLE listings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  category text NOT NULL,
  subcategory text NOT NULL,
  attributes jsonb NOT NULL,
  user_id uuid REFERENCES auth.users NOT NULL,
  created_at timestamptz DEFAULT now(),
  location text NOT NULL,
  contact text NOT NULL
);

ALTER TABLE listings ENABLE ROW LEVEL SECURITY;

-- Allow anyone to view listings
CREATE POLICY "Anyone can view listings"
  ON listings
  FOR SELECT
  TO public
  USING (true);

-- Allow authenticated users to create listings
CREATE POLICY "Authenticated users can create listings"
  ON listings
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own listings
CREATE POLICY "Users can update own listings"
  ON listings
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own listings
CREATE POLICY "Users can delete own listings"
  ON listings
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);