jQuery ->
  updateNumCalls()  # You should call this function when the user navigates
                    # to the queue page.
 
updateNumCalls = ->
  # Get the number of calls.
  $.getJSON('/num_calls').then (result) ->
    $num_calls = $('#num_calls') # Fetch the element that contains the number.
    if $num_calls.length         # Make sure it still exists on the page.
      $num_calls.html(result.num_calls)  # And if so, update the element,
      setTimeout updateNumCalls, 5000    # and queue up another query in 5 secs.