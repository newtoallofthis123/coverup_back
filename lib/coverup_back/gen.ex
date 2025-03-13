defmodule CoverupBack.Gen do
  @doc """
  The system prompt for the Google Gemini API.
  """
  def system_prompt() do
    prompt =
      "Compose a compelling and personalized cover letter addressed to the hiring manager for a given position. 
Analyze the provided resume of the applicant and the attached job description to create a letter that directly highlights 
the user's most relevant skills, experiences, and achievements as they align with the specific requirements and desired qualifications 
outlined in the job description.

Focus on making applicant's resume shine by showcasing their unique contributions and quantifiable results whenever possible. 
Ensure the language used is professional, enthusiastic, and tailored to the specific company and role. 
Avoid generic statements and instead, provide concrete examples from the resume that demonstrate a strong fit.

The cover letter should immediately capture the reader's attention and clearly articulate applicant's interest in 
the position and their value proposition to company. Do not include any address or salutation. 
Begin the cover letter directly with: 'Respected Hiring Manager'
You will be provided with a resume and job description.
    "

    prompt
  end

  @doc """
  Sends a request to the Google Gemini API.
  """
  def send_req(body, api_key) do
    url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}"

    # Increased timeouts to 30 seconds
    options = [timeout: 30_000, recv_timeout: 30_000]

    payload =
      Jason.encode!(%{
        "system_instruction" => %{
          "parts" => %{"text" => system_prompt()}
        },
        "contents" => %{
          "parts" => %{"text" => body}
        }
      })

    response = HTTPoison.post(url, payload, [], options)
    response
  end

  @doc """
  Parses the response from the Google Gemini API.
  """
  def parse_response(body) do
    parsed = Jason.decode(body)

    case parsed do
      {:ok, parsed_body} ->
        if not Map.has_key?(parsed_body, "candidates") do
          {:error, "Invalid response"}
        else
          res = Enum.at(Enum.at(parsed_body["candidates"], 0)["content"]["parts"], 0)["text"]
          res = String.replace(res, ~r/```[\w\s]*\n|\n```/, "")
          {:ok, res}
        end

      {:error, _} ->
        {:error, "Invalid Response from LLM"}
    end
  end

  @doc """
  Generates a random response based on the given schema, type, and number.
  Calls the Google Gemini API to generate the response and is hence
  blocking.
  """
  def generate_response(resume, job_description) do
    api_key = System.get_env("GOOGLE_API_KEY")

    query =
      "Here is the applicant's resume #{resume} \n\n Here is the job description #{job_description}"

    response = send_req(query, api_key)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_response(body)

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, status_code}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Sanitizes the output by removing all newlines and tabs.
  """
  def sanitise_output(output) do
    output |> String.replace(~r/\n|\t/, "")
  end
end
