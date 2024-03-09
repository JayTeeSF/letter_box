document.addEventListener("DOMContentLoaded", function() {
  const solveButton = document.getElementById("solveButton");
  const outputDiv = document.getElementById("output");

  function uniqueChars(word) {
    return [...new Set(word.split(''))];
  }

  function generateForbiddenSequences(sets) {
    let forbiddenSequences = [];
    sets.forEach(set => {
      const chars = set.split('');
      // Add double characters
      chars.forEach(char => forbiddenSequences.push(char + char));
      // Add permutations of pairs
      chars.forEach((char1, index1) => {
        chars.forEach((char2, index2) => {
          if (index1 !== index2) forbiddenSequences.push(char1 + char2);
        });
      });
    });
    return [...new Set(forbiddenSequences)];
  }

  function filterWords(sets, forbiddenSequences) {
    const letters = sets.join('').split('');
    return dictionary.filter(word => {
      const wordLetters = word.split('');
      return wordLetters.every(letter => letters.includes(letter)) &&
        !forbiddenSequences.some(seq => word.includes(seq));
    }).sort((a, b) => uniqueChars(b).length - uniqueChars(a).length || a.localeCompare(b));
  }

  // Function to filter second words based on the criteria.
  function secondWordFilter(word, lastLetter, remainingLetters, forbiddenSequences) {
    const wordLetters = word.split('');
    return wordLetters[0] === lastLetter && 
      wordLetters.every(letter => remainingLetters.includes(letter) || letter === lastLetter) &&
      !forbiddenSequences.some(seq => word.includes(seq));
  }

  function filterAndPairWords(sets, forbiddenSequences, dictionary) {
    let filteredWords = filterWords(sets, forbiddenSequences);
    // Trim to top 500 results and reverse
    filteredWords = filteredWords.slice(0, 500).reverse();

    const outputPairs = {};

    for (const foundWord of filteredWords) {
      if (foundWord.length <= 1) continue; // Skip if the word size is 1

      const lastLetter = foundWord[foundWord.length - 1];
      const remainingLetters = sets.join('').split('').filter(l => !foundWord.slice(0, -1).includes(l));

      const matches = dictionary.filter(word => secondWordFilter(word, lastLetter, remainingLetters, forbiddenSequences));

      if (matches.length > 0) {
        outputPairs[foundWord] = matches;
      }

      // Optional: break if outputPairs reach MAX_RESULTS, adjust according to your needs
      // if (Object.keys(outputPairs).length >= MAX_RESULTS) break;
    }

    return outputPairs;
  }

  solveButton.addEventListener("click", function() {
    const inputs = document.querySelectorAll("#letterSetsInput input");
    const sets = Array.from(inputs).map(input => input.value.trim().toLowerCase());

    if (sets.some(set => set.length !== 3)) {
      outputDiv.innerHTML = "<p class='text-red-500'>Each set must contain exactly 3 letters.</p>";
      return;
    }

    const forbiddenSequences = generateForbiddenSequences(sets);
    // const filteredWords = filterWords(sets, forbiddenSequences);
    //  filteredWords.map(word => `<li>${word}</li>`).join("") + 
    
    // Example call to the function - replace 'sets', 'forbiddenSequences', 'dictionary' with actual variables
    const pairs = filterAndPairWords(sets, forbiddenSequences, dictionary);

    outputDiv.innerHTML = `<div class='text-green-500'><p>Filtered Words and Pairs:</p><ul>` + 
      Object.entries(pairs).map(([foundWord, secondWords]) => `<li>${foundWord}: ${secondWords.join(', ')}</li>`).join("") + 
      "</ul></div>";
  });
});
