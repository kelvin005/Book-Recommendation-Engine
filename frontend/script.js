document.addEventListener("DOMContentLoaded", () => {
  document.getElementById("genreForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    const genre = document.getElementById("genre").value.trim();
    const resultsDiv = document.getElementById("results");
    resultsDiv.innerHTML = "Fetching recommendations...";

    try {
      const response = await fetch(`https://70lmr29os9.execute-api.us-east-2.amazonaws.com/recommend?genre=${encodeURIComponent(genre)}`);

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const raw = await response.json();
      const books = typeof raw === "string" ? JSON.parse(raw) : raw;

      if (!Array.isArray(books)) {
        throw new Error("Unexpected response format from Lambda");
      }

      resultsDiv.innerHTML = books.map(book => `
        <div class="border border-gray-200 p-4 rounded mb-4">
          <h2 class="text-lg font-semibold">${book.title}</h2>
          <p class="text-sm text-gray-600">${(book.authors || []).join(", ") || "Unknown Author"}</p>
          <p class="mt-2 text-sm">${book.description?.substring(0, 200) || "No description available."}</p>
        </div>
      `).join('');
    } catch (err) {
      resultsDiv.innerHTML = `<p class="text-red-600">Error: ${err.message}</p>`;
      console.error("Error fetching recommendations:", err);
    }
  });
});
