#include <iostream>
using namespace std;

//Recursive function to solve Tower of Hanoi
void hanoi(int n, char source, char auxiliary, char destination) {
  if (n == 1) {
    //Base case: move one disk directly
    cout << "Move disk 1 from " << source << " to " << destination << endl;
    return;
  }

  //Move n-1 disks from source to auxiliary
  hanoi(n - 1, source, destination, auxiliary);

  //Move the nth disk from source to destination
  cout << "Move disk " << n << " from " << source << " to " << destination << endl;

  //Move n-1 disks from auxiliary to destination
  hanoi(n - 1, auxiliary, source, destination);
}

int main() {
  int num_disks;

  //Prompt the user for input
  cout << "Enter the number of disks: ";
  cin >> num_disks;

  //Validate input
  if (num_disks < 1) {
    cout << "Invalid number of disks. Please enter a number greater than 0." << endl;
    return 1;
  }

  //Solve Tower of Hanoi
  hanoi(num_disks, 'A', 'B', 'C');

  return 0;
}
